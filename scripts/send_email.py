#!/usr/bin/env python3
# ==============================================================================
# Intelpress — Email SMTP Dispatcher (Hybrid Architecture / Web-Linked Briefing)
# ==============================================================================

import sys, os, smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.header import Header
from email.utils import formataddr

if len(sys.argv) < 3:
    print("Uso: python3 send_email.py <url_web_briefing> <destinatario> [asunto]")
    sys.exit(1)

web_url = sys.argv[1]
to_email = sys.argv[2].strip()
subject = sys.argv[3] if len(sys.argv) > 3 else "◆ INTELPRESS :: Executive Briefing"

smtp_server = os.getenv("INTELPRESS_SMTP_SERVER", "smtp-relay.brevo.com")
smtp_port = int(os.getenv("INTELPRESS_SMTP_PORT", "587"))
smtp_user = os.getenv("INTELPRESS_SMTP_USER", "")
smtp_pass = os.getenv("INTELPRESS_SMTP_PASS", "")

verified_sender = "intelpress.4.0@gmail.com"

if not smtp_user or not smtp_pass:
    print("⚠️  [Email] Variables INTELPRESS_SMTP_USER o INTELPRESS_SMTP_PASS no configuradas.")
    sys.exit(1)

# HTML Estructurado y Liviano (Sin Base64, enfocado en legibilidad y llamada a la acción)
html_content = f"""
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <style>
        body {{ font-family: Arial, sans-serif; background-color: #f4f4f7; color: #333333; margin: 0; padding: 0; }}
        .container {{ max-width: 600px; margin: 20px auto; background: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }}
        .header {{ border-bottom: 2px solid #1a365d; padding-bottom: 15px; margin-bottom: 20px; }}
        .header h1 {{ color: #1a365d; font-size: 20px; margin: 0; }}
        .content {{ font-size: 14px; line-height: 1.6; color: #4a5568; }}
        .cta-button {{ display: inline-block; margin-top: 25px; padding: 12px 24px; background-color: #2b6cb0; color: #ffffff; text-decoration: none; border-radius: 5px; font-weight: bold; }}
        .footer {{ margin-top: 30px; font-size: 12px; color: #a0aec0; text-align: center; border-top: 1px solid #e2e8f0; padding-top: 15px; }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>◆ INTELPRESS :: Reporte Ejecutivo</h1>
        </div>
        <div class="content">
            <p>Estimado equipo,</p>
            <p>El monitoreo automatizado de prensa correspondiente a la jornada ha finalizado con éxito bajo arquitectura soberana.</p>
            <p>El reporte completo, que incluye el desglose de métricas clave, alertas de framing estratégico y visualizaciones analíticas detalladas, se encuentra disponible en la plataforma web centralizada.</p>
            <a href="{web_url}" class="cta-button" target="_blank">Acceder al Briefing Interactivo en Línea</a>
        </div>
        <div class="footer">
            <p>Intelpress 4.0 — Sistema Automatizado de Inteligencia de Medios</p>
        </div>
    </div>
</body>
</html>
"""

msg = MIMEMultipart("alternative")
msg["Subject"] = subject
sender_name = "Intelpress Executive Briefing"
msg["From"] = formataddr((str(Header(sender_name, 'utf-8')), verified_sender))
msg["To"] = to_email

msg.attach(MIMEText(html_content, "html", "utf-8"))

try:
    print(f"-> Conectando a {smtp_server}:{smtp_port}...")
    server = smtplib.SMTP(smtp_server, smtp_port)
    server.starttls()
    server.login(smtp_user, smtp_pass)
    server.sendmail(verified_sender, [to_email], msg.as_string())
    server.quit()
    print(f"-> ÉXITO: Notificación web despachada a <{to_email}> con enlace a {web_url}")
except Exception as e:
    print(f"Error crítico en SMTP de Brevo: {e}")
    sys.exit(1)
