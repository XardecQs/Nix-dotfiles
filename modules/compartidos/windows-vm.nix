{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.compartidos.windows-vm;
  user = config.modulos.nixos.core.users.primaryUser;

  sessionScript = pkgs.writeShellScriptBin "ventana-qemu-session" ''
    LOG_FILE="$HOME/Virtualizacion/ventana-qemu-session.log"
    exec >"$LOG_FILE" 2>&1 || exec >"/tmp/ventana-qemu-session.log" 2>&1

    set -euo pipefail

    VM_DISK="$HOME/Virtualizacion/images/windows-ltsc.qcow2"
    SPICE_SOCK="/tmp/ventana-qemu-spice-''${UID}.sock"
    PID_FILE="/tmp/ventana-qemu-''${UID}.pid"

    echo "[$(date)] Iniciando ventana-qemu-session"

    cleanup() {
      echo "[$(date)] cleanup disparado ($$)"
      if [ -f "$PID_FILE" ]; then
        QEMU_PID=$(cat "$PID_FILE")
        echo "[$(date)] Matando QEMU PID=$QEMU_PID"
        kill -TERM "$QEMU_PID" 2>/dev/null || true
        for i in $(seq 1 60); do
          kill -0 "$QEMU_PID" 2>/dev/null || break
          sleep 1
        done
        kill -KILL "$QEMU_PID" 2>/dev/null || true
        rm -f "$PID_FILE"
      fi
      rm -f "$SPICE_SOCK"
      echo "[$(date)] cleanup terminado"
    }

    trap cleanup EXIT INT TERM HUP

    if [ ! -f "$VM_DISK" ]; then
      echo "[$(date)] ERROR: disco no encontrado: $VM_DISK"
      exit 1
    fi

    echo "[$(date)] Arrancando QEMU..."
    ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 \
      -name windows-ltsc \
      -machine q35,accel=kvm \
      -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
      -smp cores=4 \
      -m 8G \
      -drive file="$VM_DISK",if=virtio,cache=none,aio=native \
      -device virtio-vga \
      -spice unix=on,addr="$SPICE_SOCK",disable-ticketing=on \
      -device virtio-serial-pci \
      -chardev spicevmc,id=vdagent,name=vdagent \
      -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
      -nic user,model=virtio-net-pci \
      -audiodev spice,id=spice \
      -device ich9-intel-hda \
      -device hda-micro,audiodev=spice \
      -rtc base=localtime \
      &
    QEMU_PID=$!
    echo "$QEMU_PID" > "$PID_FILE"
    echo "[$(date)] QEMU PID=$QEMU_PID"

    echo "[$(date)] Esperando socket SPICE..."
    for i in $(seq 1 30); do
      [ -S "$SPICE_SOCK" ] && break
      sleep 0.5
    done

    if [ ! -S "$SPICE_SOCK" ]; then
      echo "[$(date)] ERROR: socket SPICE no apareció en 15s"
      wait "$QEMU_PID" || echo "[$(date)] QEMU ya murió, exit=$?"
      exit 1
    fi

    echo "[$(date)] Socket listo, lanzando cage..."

    export GDK_BACKEND=wayland

    set +e
    ${pkgs.cage}/bin/cage -- ${pkgs.virt-viewer}/bin/remote-viewer \
      --full-screen "spice+unix://$SPICE_SOCK"
    CAGE_EXIT=$?
    set -e
    echo "[$(date)] cage terminó con exit=$CAGE_EXIT"

    if ! kill -0 "$QEMU_PID" 2>/dev/null; then
      echo "[$(date)] QEMU ($QEMU_PID) ya no está corriendo"
      wait "$QEMU_PID" || echo "[$(date)] QEMU exit code=$?"
    fi

    cleanup
  '';

  sessionDesktop = pkgs.writeTextFile {
    name = "ventana-qemu-session-desktop";
    destination = "/share/wayland-sessions/windows-qemu.desktop";
    text = ''
      [Desktop Entry]
      Encoding=UTF-8
      Name=Windows (QEMU)
      Comment=Arrancar máquina virtual Windows 10 LTSC
      Exec=${sessionScript}/bin/ventana-qemu-session
      Type=Application
    '';
    passthru.providedSessions = [ "windows-qemu" ];
  };

  setupScript = pkgs.writeShellScriptBin "ventana-qemu-setup" ''
    set -euo pipefail

    IMG_DIR="$HOME/Virtualizacion/images"
    ISO_DIR="$HOME/Virtualizacion/isos"
    DISK="$IMG_DIR/windows-ltsc.qcow2"

    mkdir -p "$IMG_DIR" "$ISO_DIR"

    if [ -f "$DISK" ]; then
      if [ "''${1:-}" != "--force" ]; then
        echo "El disco ya existe: $DISK"
        echo "Usá --force para recrearlo."
        exit 1
      fi
      rm -f "$DISK"
    fi

    echo "Creando disco virtual de ${cfg.diskSize}..."
    ${pkgs.qemu_kvm}/bin/qemu-img create -f qcow2 "$DISK" "${cfg.diskSize}"

    echo ""
    echo "Disco creado: $DISK"
    echo ""
    echo "Para instalar Windows 10 LTSC:"
    echo "  1. Colocá la ISO de Windows 10 LTSC en:"
    echo "     $ISO_DIR/"
    echo "  2. Descargá virtio-win ISO desde:"
    echo "     https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
    echo "     y guardala como: $ISO_DIR/virtio-win.iso"
    echo "  3. Ejecutá: ventana-qemu-instalar"
    echo ""
  '';

  installScript = pkgs.writeShellScriptBin "ventana-qemu-instalar" ''
    set -euo pipefail

    IMG_DIR="$HOME/Virtualizacion/images"
    ISO_DIR="$HOME/Virtualizacion/isos"
    DISK="$IMG_DIR/windows-ltsc.qcow2"

    if [ ! -f "$DISK" ]; then
      echo "Ejecutá ventana-qemu-setup primero."
      exit 1
    fi

    WIN_ISO=""
    for iso in "$ISO_DIR"/Win{10,dows10}*.iso "$ISO_DIR"/*.iso; do
      [ -f "$iso" ] && WIN_ISO="$iso" && break
    done

    if [ -z "$WIN_ISO" ] || [ ! -f "$WIN_ISO" ]; then
      echo "ISO de Windows no encontrada en $ISO_DIR/"
      echo "Renombrala como Win10-LTSC.iso o similar."
      exit 1
    fi

    VIRTIO_ISO="$ISO_DIR/virtio-win.iso"
    if [ ! -f "$VIRTIO_ISO" ]; then
      echo "virtio-win ISO no encontrada: $VIRTIO_ISO"
      echo "Descargala: https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
      exit 1
    fi

    echo "ISO detectada: $WIN_ISO"
    echo "Arrancando instalador de Windows..."
    echo ""
    echo "IMPORTANTE: Cuando Windows pregunte por el disco, cargá los drivers"
    echo "            desde el CD-ROM de virtio-win:"
    echo "              virtio-win.iso/amd64/2k25 → NetKVM  (red)"
    echo "              virtio-win.iso/amd64/2k25 → viostor  (disco)"
    echo ""

    ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 \
      -name windows-ltsc-setup \
      -machine q35,accel=kvm \
      -cpu host \
      -smp cores=${toString cfg.cores} \
      -m ${cfg.ram} \
      -drive file="$DISK",if=virtio \
      -cdrom "$WIN_ISO" \
      -drive file="$VIRTIO_ISO",media=cdrom \
      -boot order=d \
      -device virtio-gpu-gl \
      -display gtk,gl=on \
      -device virtio-serial-pci \
      -chardev spicevmc,id=vdagent,name=vdagent \
      -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
      -nic user,model=virtio-net-pci \
      -audiodev pa,id=pa,server=unix:/run/user/$(id -u)/pulse/native \
      -device ich9-intel-hda \
      -device hda-micro,audiodev=pa \
      -rtc base=localtime
  '';
in
{
  options.modulos.compartidos.windows-vm = {
    enable = lib.mkEnableOption "windows-vm";
    sistema = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar parte del sistema (qemu_kvm, OVMF, sessionPackages)";
    };
    usuario = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar parte de usuario (scripts setup/instalación, directorios)";
    };

    diskSize = lib.mkOption {
      type = lib.types.str;
      default = "64G";
      description = "Tamaño del disco virtual qcow2";
    };

    ram = lib.mkOption {
      type = lib.types.str;
      default = "8G";
      description = "RAM asignada a la VM";
    };

    cores = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Núcleos asignados a la VM";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.sistema {
        environment.systemPackages = with pkgs; [
          qemu_kvm
          OVMF
          cage
          virt-viewer
        ];

        services.displayManager.sessionPackages = [ sessionDesktop ];
      })

      (lib.mkIf cfg.usuario {
        home-manager.users.${user} = {
          home.packages = with pkgs; [
            qemu_kvm
            OVMF
            setupScript
            installScript
          ];

          home.activation.windowsVmDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            mkdir -p "$HOME/Virtualizacion/images" "$HOME/Virtualizacion/isos"
          '';
        };
      })
    ]
  );
}
