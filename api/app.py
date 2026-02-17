from fastapi import FastAPI, Query
from dotenv import load_dotenv
import os
import pyodbc

load_dotenv()

app = FastAPI(title="Komatsu KPI API (Sample)")

def get_conn():
    server = os.getenv("AZURE_SQL_SERVER")
    database = os.getenv("AZURE_SQL_DATABASE")
    user = os.getenv("AZURE_SQL_USER")
    password = os.getenv("AZURE_SQL_PASSWORD")
    driver = os.getenv("AZURE_SQL_DRIVER", "ODBC Driver 18 for SQL Server")

    # Encrypt=yes is recommended for Azure SQL
    conn_str = (
        f"DRIVER={{{driver}}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={user};"
        f"PWD={password};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )
    return pyodbc.connect(conn_str)

def fetch_all(query: str):
    with get_conn() as conn:
        cur = conn.cursor()
        cur.execute(query)
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        return [dict(zip(cols, r)) for r in rows]

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/kpi/utilization")
def kpi_utilization(top: int = Query(100, ge=1, le=500)):
    sql = f"""
    SELECT TOP ({top})
      full_date, hour_of_day, site_name, truck_name, utilization_pct,
      active_seconds, total_seconds
    FROM dbo.vw_kpi_utilization
    ORDER BY full_date DESC, hour_of_day DESC;
    """
    return fetch_all(sql)

@app.get("/kpi/fuel-efficiency")
def kpi_fuel_efficiency(top: int = Query(100, ge=1, le=500)):
    sql = f"""
    SELECT TOP ({top})
      full_date, hour_of_day, site_name, truck_name,
      liters_per_ton, fuel_liters, payload_tons
    FROM dbo.vw_kpi_fuel_efficiency
    ORDER BY full_date DESC, hour_of_day DESC;
    """
    return fetch_all(sql)

@app.get("/kpi/overheat-events")
def kpi_overheat_events(top: int = Query(200, ge=1, le=1000)):
    sql = f"""
    SELECT TOP ({top})
      event_time, site_name, truck_name, engine_temp
    FROM dbo.vw_kpi_overheat_events
    ORDER BY event_time DESC;
    """
    return fetch_all(sql)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
