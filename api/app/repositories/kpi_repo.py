from app.db import get_connection

def fetch_all(query: str):
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(query)
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        return [dict(zip(cols, r)) for r in rows]

def get_utilization(top: int):
    return fetch_all(f"""
        SELECT TOP ({top})
          full_date, hour_of_day, site_name, truck_name,
          utilization_pct
        FROM dbo.vw_kpi_utilization
        ORDER BY full_date DESC, hour_of_day DESC
    """)

def get_fuel_efficiency(top: int):
    return fetch_all(f"""
        SELECT TOP ({top})
          full_date, hour_of_day, site_name, truck_name,
          liters_per_ton
        FROM dbo.vw_kpi_fuel_efficiency
        ORDER BY full_date DESC, hour_of_day DESC
    """)

def get_overheat(top: int):
    return fetch_all(f"""
        SELECT TOP ({top})
          event_time, site_name, truck_name, engine_temp
        FROM dbo.vw_kpi_overheat_events
        ORDER BY event_time DESC
    """)
