import csv
from datetime import datetime

ALLOWED_STATUS = {"ACTIVE","IDLE","DOWN"}

def validate(path: str) -> list[str]:
    errors = []
    with open(path, newline="", encoding="utf-8") as f:
        r = csv.DictReader(f)
        for i, row in enumerate(r, start=2):
            # required
            for col in ["event_time","truck_id","site_id","status","fuel_rate","payload","engine_temp"]:
                if row.get(col) in (None, ""):
                    errors.append(f"Line {i}: missing {col}")

            # status
            if row.get("status") and row["status"] not in ALLOWED_STATUS:
                errors.append(f"Line {i}: invalid status {row['status']}")

            # types/ranges (basic)
            try:
                _ = datetime.fromisoformat(row["event_time"].replace("Z","+00:00"))
            except Exception:
                errors.append(f"Line {i}: invalid event_time {row['event_time']}")

            try:
                fuel = float(row["fuel_rate"])
                if fuel < 0: errors.append(f"Line {i}: fuel_rate < 0")
            except Exception:
                errors.append(f"Line {i}: invalid fuel_rate")

            try:
                payload = float(row["payload"])
                if payload < 0: errors.append(f"Line {i}: payload < 0")
            except Exception:
                errors.append(f"Line {i}: invalid payload")

            try:
                temp = float(row["engine_temp"])
                if temp < 0 or temp > 200: errors.append(f"Line {i}: engine_temp out of range")
            except Exception:
                errors.append(f"Line {i}: invalid engine_temp")

    return errors

if __name__ == "__main__":
    file_path = "data-ingestion/sample-data/telemetry_generated.csv"
    errs = validate(file_path)
    if errs:
        print("Validation failed:")
        for e in errs[:30]:
            print("-", e)
        raise SystemExit(1)
    print("Validation OK:", file_path)
