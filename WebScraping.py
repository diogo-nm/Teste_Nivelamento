import requests
import zipfile
import os
from bs4 import BeautifulSoup
import pdfplumber
import csv

# URL da página contendo os links
URL = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-dasociedade/atualizacao-do-rol-de-procedimentos"

# Diretório para salvar os arquivos
DOWNLOAD_DIR = "downloads"
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

# Obtendo o conteúdo da página
response = requests.get(URL)
soup = BeautifulSoup(response.text, "html.parser")

# Procurando links para os anexos PDF
pdf_links = []
for link in soup.find_all("a", href=True):
    if "Anexo" in link.text and link["href"].endswith(".pdf"):
        pdf_links.append(link["href"])

# Baixando os PDFs
pdf_files = []
for pdf_link in pdf_links:
    pdf_name = pdf_link.split("/")[-1]
    pdf_path = os.path.join(DOWNLOAD_DIR, pdf_name)
    pdf_files.append(pdf_path)
    
    with open(pdf_path, "wb") as f:
        f.write(requests.get(pdf_link).content)
    print(f"Baixado: {pdf_name}")

# Criando um arquivo ZIP
zip_path = os.path.join(DOWNLOAD_DIR, "anexos.zip")
with zipfile.ZipFile(zip_path, "w") as zipf:
    for pdf in pdf_files:
        zipf.write(pdf, os.path.basename(pdf))

print(f"Arquivos compactados em {zip_path}")

# Extração de dados do PDF do Anexo I e salvar em CSV
csv_path = os.path.join(DOWNLOAD_DIR, "Rol_de_Procedimentos.csv")
with pdfplumber.open(pdf_files[0]) as pdf:
    with open(csv_path, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        for page in pdf.pages:
            table = page.extract_table()
            if table:
                writer.writerows(table)

print(f"Dados extraídos e salvos em {csv_path}")

# Compactação do CSV
zip_csv_path = os.path.join(DOWNLOAD_DIR, "Teste_seu_nome.zip")
with zipfile.ZipFile(zip_csv_path, "w") as zipf:
    zipf.write(csv_path, os.path.basename(csv_path))

print(f"CSV compactado em {zip_csv_path}")
