
import pandas as pd
import numpy as np
import uuid
from datetime import datetime, timedelta
import random

random.seed(42)
np.random.seed(42)

# =========================
# CONFIG
# =========================
N_USERS = 50000
N_PRODUCTS = 500
N_SESSIONS = 300000

START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2025, 12, 31)

# =========================
# HELPERS
# =========================

def random_date(start, end):
    return start + timedelta(
        seconds=random.randint(0, int((end - start).total_seconds()))
    )

def uuid_list(n):
    return [str(uuid.uuid4()) for _ in range(n)]

# =========================
# USERS
# =========================

countries = [
    "Egypt", "Saudi Arabia", "UAE",
    "Jordan", "Kuwait", "Qatar"
]

sources = [
    "Google",
    "Facebook",
    "Organic",
    "Email",
    "Direct"
]

print("Generating users...")

users = pd.DataFrame({
    "user_id": uuid_list(N_USERS),
    "signup_date": [
        random_date(START_DATE, END_DATE)
        for _ in range(N_USERS)
    ],
    "country": np.random.choice(
        countries,
        N_USERS,
        p=[0.4,0.15,0.15,0.1,0.1,0.1]
    ),
    "acquisition_source": np.random.choice(
        sources,
        N_USERS,
        p=[0.3,0.25,0.2,0.1,0.15]
    )
})

# Missing values
users.loc[
    users.sample(frac=0.02, random_state=42).index,
    "country"
] = None

# =========================
# PRODUCTS
# =========================

print("Generating products...")

categories = [
    "Electronics",
    "Fashion",
    "Beauty",
    "Home",
    "Luxury"
]

products = pd.DataFrame({
    "product_id": uuid_list(N_PRODUCTS),
    "product_name": [
        f"Product_{i}"
        for i in range(N_PRODUCTS)
    ],
    "category": np.random.choice(
        categories,
        N_PRODUCTS,
        p=[0.35,0.25,0.15,0.15,0.10]
    )
})

base_prices = {
    "Electronics": 700,
    "Fashion": 80,
    "Beauty": 40,
    "Home": 150,
    "Luxury": 2500
}

products["price"] = products["category"].apply(
    lambda c: round(
        np.random.normal(base_prices[c], base_prices[c]*0.25),
        2
    )
)

# =========================
# SESSIONS
# =========================

print("Generating sessions...")

session_ids = uuid_list(N_SESSIONS)

session_users = np.random.choice(
    users["user_id"],
    N_SESSIONS
)

session_device = np.random.choice(
    ["Desktop","Mobile"],
    N_SESSIONS,
    p=[0.35,0.65]
)

session_sources = np.random.choice(
    sources,
    N_SESSIONS,
    p=[0.3,0.25,0.2,0.1,0.15]
)

sessions = pd.DataFrame({
    "session_id": session_ids,
    "user_id": session_users,
    "session_start": [
        random_date(START_DATE, END_DATE)
        for _ in range(N_SESSIONS)
    ],
    "device_type": session_device,
    "traffic_source": session_sources
})

# missing source
sessions.loc[
    sessions.sample(frac=0.03, random_state=42).index,
    "traffic_source"
] = None

# =========================
# EVENTS
# =========================

print("Generating events...")

product_lookup = products.set_index("product_id")
user_signup = users.set_index("user_id")["signup_date"]

events = []

for idx, row in sessions.iterrows():

    if idx % 50000 == 0:
        print(f"Session {idx:,}/{N_SESSIONS:,}")

    session_id = row["session_id"]
    user_id = row["user_id"]
    session_time = row["session_start"]
    device = row["device_type"]
    source = row["traffic_source"]

    n_products = np.random.randint(1, 6)

    viewed_products = np.random.choice(
        products["product_id"],
        n_products,
        replace=False
    )

    returning_user = (
        session_time >
        user_signup.loc[user_id] + timedelta(days=30)
    )

    for p in viewed_products:

        category = product_lookup.loc[p, "category"]

        add_prob = 0.25
        checkout_prob = 0.60
        purchase_prob = 0.50

        if returning_user:
            add_prob += 0.10
            purchase_prob += 0.10

        # Facebook low quality
        if source == "Facebook":
            purchase_prob -= 0.20

        # Luxury weak conversion
        if category == "Luxury":
            purchase_prob -= 0.20

        # Mobile checkout bug
        if device == "Mobile":
            checkout_prob -= 0.40

        add_prob = max(add_prob, 0.01)
        checkout_prob = max(checkout_prob, 0.01)
        purchase_prob = max(purchase_prob, 0.01)

        t1 = session_time + timedelta(
            minutes=np.random.randint(1, 20)
        )

        events.append([
            str(uuid.uuid4()),
            session_id,
            user_id,
            p,
            "product_view",
            t1
        ])

        if np.random.rand() < add_prob:

            t2 = t1 + timedelta(
                minutes=np.random.randint(1, 10)
            )

            events.append([
                str(uuid.uuid4()),
                session_id,
                user_id,
                p,
                "add_to_cart",
                t2
            ])

            if np.random.rand() < checkout_prob:

                t3 = t2 + timedelta(
                    minutes=np.random.randint(1, 10)
                )

                events.append([
                    str(uuid.uuid4()),
                    session_id,
                    user_id,
                    p,
                    "begin_checkout",
                    t3
                ])

                if np.random.rand() < purchase_prob:

                    t4 = t3 + timedelta(
                        minutes=np.random.randint(1, 5)
                    )

                    events.append([
                        str(uuid.uuid4()),
                        session_id,
                        user_id,
                        p,
                        "purchase",
                        t4
                    ])

events = pd.DataFrame(
    events,
    columns=[
        "event_id",
        "session_id",
        "user_id",
        "product_id",
        "event_name",
        "event_time"
    ]
)

# =========================
# DATA QUALITY ISSUES
# =========================

print("Injecting data issues...")

# duplicates 1%
dupes = events.sample(
    frac=0.01,
    random_state=42
)

events = pd.concat(
    [events, dupes],
    ignore_index=True
)

# orphan sessions 0.5%
orphans = events.sample(
    frac=0.005,
    random_state=11
).copy()

orphans["session_id"] = [
    str(uuid.uuid4())
    for _ in range(len(orphans))
]

events = pd.concat(
    [events, orphans],
    ignore_index=True
)

# invalid sequence
bad_idx = events.sample(
    frac=0.003,
    random_state=15
).index

events.loc[bad_idx, "event_name"] = np.random.choice(
    ["purchase","begin_checkout"],
    len(bad_idx)
)

# timestamp anomalies
time_idx = events.sample(
    frac=0.003,
    random_state=19
).index

events.loc[time_idx, "event_time"] = (
    pd.to_datetime(events.loc[time_idx, "event_time"])
    + pd.to_timedelta(
        np.random.randint(5, 15, len(time_idx)),
        unit="D"
    )
)

# =========================
# EXPORT
# =========================

print("Saving CSV files...")

users.to_csv("users.csv", index=False)
products.to_csv("products.csv", index=False)
sessions.to_csv("sessions.csv", index=False)
events.to_csv("events.csv", index=False)

print("\\nGeneration Complete")
print(f"Users: {len(users):,}")
print(f"Products: {len(products):,}")
print(f"Sessions: {len(sessions):,}")
print(f"Events: {len(events):,}")
