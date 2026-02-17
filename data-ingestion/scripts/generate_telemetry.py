import csv
import random
from datetime import datetime, timedelta, timezone

STATUSES = ["ACTIVE", "IDLE", "DOWN"]

def generate_rows(
    out_path: str,
    start_time: datetime,
    minutes: int = 120,
    truck_ids=(101, 102, 201),
    site_ids=(1, 2),
):
    rng = random.Random(42)

    with open(out_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["event_time","truck_id","site_id","status","fuel_rate","payload","engine_temp","duration_seconds"])

        for m in range(minutes):
            t = start_time + timedelta(minutes=m)

            for truck_id in truck_ids:
                site_id = rng.choice(site_ids)
                status = rng.choices(STATUSES, weights=[0.75, 0.20, 0.05])[0]

                if status == "ACTIVE":
                    fuel_rate = round(rng.uniform(70, 110), 1)
                    payload = round(rng.uniform(80, 160), 1)
                    engine_temp = round(rng.uniform(80, 102), 1)
                elif status == "IDLE":
                    fuel_rate = round(rng.uniform(5, 20), 1)
                    payload = 0.0
                    engine_temp = round(rng.uniform(65, 85), 1)
                else:  # DOWN
                    fuel_rate = 0.0
                    payload = 0.0
                    engine_temp = round(rng.uniform(60, 80), 1)

                duration_seconds = 60
                writer.writerow([t.replace(tzinfo=timezone.utc).isoformat(), truck_id, site_id, status, fuel_rate, payload, engine_temp, duration_seconds])

if __name__ == "__main__":
    start = datetime(2026, 2, 15, 10, 0, 0)
    generate_rows("data-ingestion/sample-data/telemetry_generated.csv", start_time=start, minutes=60)
    print("Generated: data-ingestion/sample-data/telemetry_generated.csv")
