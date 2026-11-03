from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
c = canvas.Canvas(r'D:\UTN_GIT\GIT_BASE DE DATOS\UNIDAD6\informe_TPU6_Mendez_Reynoso.pdf', pagesize=A4)
w,h = A4
c.setFont('Helvetica-Bold',18)
c.drawCentredString(w/2,h/2+20,'TP UNIDAD 6 - MANTENIMIENTO, RESPALDO Y RECUPERACION')
c.setFont('Helvetica-Bold',14)
c.drawCentredString(w/2,h/2-20,'Joaquin Antonio Mendez Reynoso')
c.showPage()
y = h-60
c.setFont('Helvetica',9)
with open(r'D:\UTN_GIT\GIT_BASE DE DATOS\UNIDAD6\informe_TPU6_Mendez_Reynoso.md','r',encoding='utf-8') as f:
    for line in f:
        s = line.rstrip()
        if not s.strip():
            y -= 6
            if y < 40:
                c.showPage(); c.setFont('Helvetica',9); y = h-60
            continue
        if y < 40:
            c.showPage(); c.setFont('Helvetica',9); y = h-60
        if s.strip().startswith('#'):
            c.setFont('Helvetica-Bold',12)
            t = s.strip().lstrip('#').strip()
            c.drawString(40,y,t)
            c.setFont('Helvetica',9)
            y -= 16
            continue
        c.drawString(40,y,s.replace('**','').replace('','')[:95])
        y -= 11
c.save()

