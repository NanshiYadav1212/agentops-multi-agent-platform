import asyncio
from pathlib import Path
import asyncpg

from config import get_settings


async def main():
    settings = get_settings()

    conn = await asyncpg.connect(
        settings.database_url,
        ssl=False,
        statement_cache_size=0,
    )

    try:
        sql = Path(
            "db/migrations/001_initial_schema.sql"
        ).read_text(encoding="utf-8")

        await conn.execute(sql)

        print("MIGRATION 001 APPLIED")
    finally:
        await conn.close()


if __name__ == "__main__":
    asyncio.run(main())
