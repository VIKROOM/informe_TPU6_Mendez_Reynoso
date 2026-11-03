from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
c = canvas.Canvas('informe_TPU6_Mendez_Reynoso.pdf', pagesize=A4)
with open('informe_TPU6_Mendez_Reynoso.md','r',encoding='utf-8') as f:
    text = f.read()
c.setFont('Helvetica',9)
y = 800
for line in text.splitlines():
    if y < 40:
        c.showPage()
        c.setFont('Helvetica',9)
        y = 800
    s = line.replace('#','').replace('*','').replace('','').replace('>','')
    c.drawString(40,y,s[:90])
    y -= 11
c.save()

