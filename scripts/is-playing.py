#!/usr/bin/env python3
import subprocess
import time 

process = subprocess.Popen(["playerctl", "--follow", "status"], stdout=subprocess.PIPE, text=True)
ultimo_estado = None

for estado in process.stdout:
    estado = estado.strip()
    if estado == "Playing":
        if ultimo_estado != "musica":
            ultimo_estado = "musica"
        
        time.sleep(0.3)
        titulo  = subprocess.run(["playerctl", "metadata", "title"],      capture_output=True, text=True).stdout.strip()
        artista = subprocess.run(["playerctl", "metadata", "artist"],     capture_output=True, text=True).stdout.strip()
        cover   = subprocess.run(["playerctl", "metadata", "mpris:artUrl"], capture_output=True, text=True).stdout.strip()

        summary = "Now Playing"
        body    = f"<b>{titulo}</b>\n{artista}"

        cmd = [
            "notify-send",
            "-t", "6500",
            "-u", "low",
            "-i", "media-playback-start",
            "-h", "int:transient:1",
        ]

        # Agrega la portada solo si existe
        if cover:
            cmd += ["-h", f"string:image-path:{cover}"]

        cmd += [summary, body]
        subprocess.run(cmd)

    elif estado in ("Paused", "Stopped"):
        if ultimo_estado != "normal":
            ultimo_estado = "normal"
