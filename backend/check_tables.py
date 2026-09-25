import asyncio
import asyncpg
from config import get_settings

async def main():
    settings = get_settings()

    conn = await asyncpg.connect(
        settings.database_url,
        ssl=False,
        statement_cache_size=0,
    )

    rows = await conn.fetch("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        ORDER BY table_name
    """)

    for row in rows:
        print(row["table_name"])

    await conn.close()

asyncio.run(main())
