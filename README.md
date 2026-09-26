![Python](https://img.shields.io/badge/Python-3.12-blue)
![FastAPI](https://img.shields.io/badge/FastAPI-Latest-green)
![Next.js](https://img.shields.io/badge/Next.js-14-black)
![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)
![LangGraph](https://img.shields.io/badge/LangGraph-Agentic-orange)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?logo=redis&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow)

# AgentOps — Multi-Agent Task Runner & Orion Assistant

An end-to-end multi-agent orchestration platform powered by **LangGraph**, **FastAPI**, **Next.js 14**, and an **Electron** desktop assistant (**Orion**).

---

## 🔗 Live Demos & Links
- **🌐 Frontend (Web App)**: https://agentops-multi-agent-platform-lkra6d6f0.vercel.app
- **⚙️ Backend API / Swagger Docs**: https://agentops-multi-agent-platform.onrender.com/docs
  
---

## ✨ Core Features

- **Multi-Agent Orchestration**: LangGraph Supervisor breaks complex goals into dynamic task DAGs.
- **Real-Time Streaming**: Live execution logs and progress streaming over WebSocket & Redis Pub/Sub.
- **Orion Desktop Assistant**: Electron-based desktop overlay (`Ctrl + Space`) with local OCR and vision-based screen context.
- **RAG & Document Intelligence**: Automated document processing (CSV, Excel, Images/OCR) via Supabase storage.
- **Docker Sandbox Execution**: Secure code execution across 7 languages in isolated containers.
- **GitHub & Tool Automation**: Full repository management, issue creation, and web research capabilities.

---

## 🛠️ Tech Stack

| Domain | Technologies |
|---|---|
| **AI & Agents** | LangGraph, Groq, OpenAI, RAG, Local OCR |
| **Frontend** | Next.js 14, React 18, Tailwind CSS |
| **Desktop App** | Electron, TypeScript |
| **Backend** | FastAPI, Python 3.12, WebSockets |
| **Database & Cache** | PostgreSQL, Redis, Supabase |
| **Infrastructure** | Docker, JWT Auth |

---

## 🚀 Quick Start

```bash
# 1. Clone & Setup
git clone https://github.com/NanshiYadav1212/agentops-multi-agent-platform.git
cd agentops
bash setup.sh

# 2. Run Database & Cache
docker compose up -d

# 3. Start Backend
source backend/.venv/bin/activate
cd backend && uvicorn main:app --reload

# 4. Start Frontend
cd frontend && npm run dev
