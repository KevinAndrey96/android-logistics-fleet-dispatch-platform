# Logistics Fleet Dispatch Platform

[![CI - Build, Test & Verify](https://github.com/KevinAndrey96/logistics-fleet-dispatch-platform/actions/workflows/ci.yml/badge.svg)](https://github.com/KevinAndrey96/logistics-fleet-dispatch-platform/actions/workflows/ci.yml)
[![PHP Version](https://img.shields.io/badge/PHP-8.1%20%7C%208.2-777BB4?style=flat-square&logo=php&logoColor=white)](https://www.php.net/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Android](https://img.shields.io/badge/Android-Native%20Java-3DDC84?style=flat-square&logo=android&logoColor=white)](https://developer.android.com/)
[![Docker](https://img.shields.io/badge/Docker-Compose%20Ready-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)

A full-stack, enterprise-grade logistics and on-demand urban dispatch platform. The platform coordinates the end-to-end delivery lifecycle across three integrated systems: a centralized web dispatch management backoffice, a native Android application for customers to request shipments, and a native Android application for couriers and drivers with real-time GPS tracking, in-app navigation, digital signature capture, and photo proof of delivery.

---

## 🏛️ System Architecture

The platform operates as a unified monorepo connecting mobile clients, field couriers, and central dispatch operators through a high-performance backend:

```mermaid
flowchart TD
    subgraph Clients["📱 Mobile Ecosystem"]
        UserApp["Android Customer App\n(Order Placement, Maps & Fare Est.)"]
        CourierApp["Android Courier App\n(Job Dispatch, Signature & Camera Proof)"]
    end

    subgraph Gateway["🌐 API & Dispatch Gateway"]
        APIs["Mobile JSON Endpoints\n(/backend/config/)"]
        WebAdmin["Web Dispatch Backoffice\n(Live Fleet Monitoring & CRUD)"]
    end

    subgraph DataLayer["🗄️ Relational Persistence"]
        DB[(MySQL 8.0 Engine\nInnoDB, utf8mb4)]
    end

    UserApp -->|POST /config/Envia_servicio.php| APIs
    UserApp -->|GET /config/Lista_serviciossolicitados.php| APIs
    CourierApp -->|GET /config/Mensajeros/Lista_serviciosporasignar.php| APIs
    CourierApp -->|POST /config/Mensajeros/Envia_asignacion.php| APIs
    CourierApp -->|POST /backend/upload.php (Signature/Photo)| APIs
    WebAdmin -->|Live Fleet Tracking & Dispatch Control| APIs
    APIs -->|PDO Database Layer| DB
    WebAdmin -->|jqGrid Server-Side Pagination| DB
```

---

## 📂 Monorepo Organization

```
logistics-fleet-dispatch-platform/
├── apps/
│   ├── android-customer/       # Native Android application for business & retail customers
│   │   ├── app/src/main/       # Java activities, models, layouts, Google Maps integration
│   │   └── build.gradle        # Gradle application build configuration
│   └── android-courier/        # Native Android application for drivers and fleet couriers
│       ├── app/src/main/       # GPS tracking, navigation drawer, digital signature, photo proof
│       └── build.gradle        # Gradle application build configuration
├── backend/                    # Central Web Dispatch Portal & Mobile REST APIs
│   ├── config/                 # Mobile API endpoints (authentication, order lifecycle, tracking)
│   ├── controlador/            # PDO database abstraction and compatibility layer
│   ├── Data/                   # jqGrid server-side data endpoints for backoffice tables
│   ├── Edit/                   # CRUD transaction handlers (add, edit, delete operations)
│   ├── inc/                    # UI layouts, ribbons, and navigational components
│   ├── js/ & css/              # SmartAdmin and jqGrid frontend assets
│   ├── admin.php               # System administrators management
│   ├── clientes.php            # Customer CRM and directory
│   ├── mensajeros.php          # Field courier fleet management
│   ├── servicios.php           # Active dispatch and delivery order board
│   └── index.php               # Secure operator authentication portal
├── database/
│   ├── schema.sql              # Relational DDL schema (Administradores, Clientes, Mensajeros, Servicios)
│   ├── seeds.sql               # Realistic seed dataset with geolocated couriers and shipments
│   └── verify_database.php     # Automated verification script for CI
├── docker-compose.yml          # Container orchestration (PHP 8.2 Apache + MySQL 8.0 + Mailpit)
├── Dockerfile                  # Production-ready PHP 8.2 Apache container image
├── Makefile                    # Developer workflow automation
├── .env.example                # Environment configuration template
└── .github/workflows/ci.yml    # Continuous Integration pipeline
```

---

## ⚡ Key Capabilities & Technical Highlights

### 1. Centralized Dispatch Management Backoffice
- **Fleet Coordination**: Real-time overview of active couriers (`Disponible`, `En Servicio`, `Inactivo`) with geographic coordinates.
- **Service Board**: Multi-stage delivery state machine (`Espera` ➔ `Asignado` ➔ `Recogido` ➔ `Entregado`).
- **High-Performance Grid**: jqGrid integration with server-side pagination, multi-column sorting, and asynchronous inline editing.

### 2. Native Android Courier App (`apps/android-courier`)
- **Real-Time Job Dispatch**: Push/pull listing of pending jobs with automated distance and route estimation.
- **Proof of Delivery (PoD)**: On-device digital signature canvas (`actvity_firma.xml`) and camera integration for physical receipt capture.
- **Live Location Reporting**: Periodic GPS coordinate dispatch to keep the central monitoring board up to date.

### 3. Native Android Customer App (`apps/android-customer`)
- **Interactive Map Pinning**: Google Maps integration for selecting origin and destination points with route visualization.
- **Fare Calculation Engine**: Dynamic fare evaluation based on calculated distance (Km) and shipment specifications.
- **Live Status Tracking**: Detailed progress monitor showing assigned driver details (name, phone, license plate) and delivery milestones.

### 4. Modernized Backend & Compatibility Layer
- **PHP 8.1 & 8.2 Ready**: Transparent database abstraction layer powered by PDO, fully compatible with modern PHP versions while retaining backwards compatibility.
- **Secure Architecture**: Environment-driven credentials, prepared queries, and structured JSON output for mobile consumers.

---

## 🚀 Quick Start with Docker

### Prerequisites
- Docker Engine 20.10+ and Docker Compose v2+
- Make (optional, for CLI shortcuts)

### 1. Initialize Environment
```bash
cp .env.example .env
```

### 2. Launch Container Stack
```bash
make up
# Or directly with Docker Compose:
docker compose up -d --build
```

The stack exposes the following services:
- **Web Dispatch Backoffice**: [http://localhost:8080](http://localhost:8080)
- **MySQL 8.0 Database**: `localhost:3306`
- **Mailpit SMTP Inspector**: [http://localhost:8025](http://localhost:8025)

### 3. Database Migration & Seeding
```bash
make migrate
make seed
```

Default backoffice supervisor credentials:
- **Username / Documento**: `1018456789`
- **Password**: `AdminLogistics2026!`

---

## 🧪 Testing & Continuous Integration

The repository includes an automated GitHub Actions CI pipeline running on every push:
- **PHP Syntax & Linting**: Multi-version validation across PHP 8.1 and PHP 8.2.
- **Database Schema Validation**: Real MySQL 8.0 service container executing DDL migrations and verifying relational constraints.
- **Mobile Project Sanity**: Verification of Android manifest declarations, project hierarchies, and clean artifact state (zero binaries committed).

To run verification locally:
```bash
make test
```

---

## 📄 License

This project is licensed under the MIT License.
