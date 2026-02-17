from fastapi import FastAPI
from app.repositories import kpi_repo

app = FastAPI(title="Komatsu KPI API")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/kpi/utilization")
def utilization(top: int = 100):
    return kpi_repo.get_utilization(top)

@app.get("/kpi/fuel-efficiency")
def fuel_efficiency(top: int = 100):
    return kpi_repo.get_fuel_efficiency(top)

@app.get("/kpi/overheat-events")
def overheat(top: int = 100):
    return kpi_repo.get_overheat(top)
