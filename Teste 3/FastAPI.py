from fastapi import FastAPI, Query
import pandas as pd
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Habilita CORS para o frontend consumir a API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Carregar os dados do CSV
CSV_FILE = "operadoras.csv"  # Nome do arquivo CSV com os dados

try:
    df = pd.read_csv(CSV_FILE, delimiter=';', dtype=str)
except Exception as e:
    print(f"Erro ao carregar o CSV: {e}")
    df = pd.DataFrame()

@app.get("/buscar")
def buscar_operadora(q: str = Query(..., min_length=2, description="Texto a ser buscado")):
    """Busca textual nas operadoras de saúde pelo nome fantasia ou razão social."""
    if df.empty:
        return {"error": "Base de dados não carregada."}
    
    resultado = df[df['Nome_Fantasia'].str.contains(q, case=False, na=False) | df['Razao_Social'].str.contains(q, case=False, na=False)]
    return resultado.to_dict(orient='records')

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
