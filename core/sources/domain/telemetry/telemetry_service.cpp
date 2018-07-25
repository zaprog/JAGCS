#include "telemetry_service.h"

// Qt
#include <QMap>
#include <QDebug>

// Internal
#include "settings_provider.h"

#include "vehicle_service.h"
#include "vehicle.h"

#include "telemetry.h"
#include "telemetry_portion.h"
#include "vehicle_telemetry_factory.h"

using namespace domain;

class TelemetryService::Impl
{
public:
    domain::VehicleService* service;

    QMap<int, data_source::Telemetry*> vehicleNodes;
    data_source::Telemetry radioNode;

    Impl():
        radioNode(data_source::Telemetry::Root)
    {}
};

TelemetryService::TelemetryService(VehicleService* service, QObject* parent):
    QObject(parent),
    d(new Impl())
{
    qRegisterMetaType<data_source::Telemetry::TelemetryList>("Telemetry::TelemetryList");
    qRegisterMetaType<data_source::Telemetry::TelemetryMap>("Telemetry::TelemetryMap");

    d->service = service;
    connect(d->service, &VehicleService::vehicleAdded, this, &TelemetryService::onVehicleAdded);
    connect(d->service, &VehicleService::vehicleRemoved, this, &TelemetryService::onVehicleRemoved);

    data_source::VehicleTelemetryFactory factory;
    for (const dto::VehiclePtr& vehicle: d->service->vehicles())
    {
        d->vehicleNodes[vehicle->id()] = factory.create();
    }
}

TelemetryService::~TelemetryService()
{}

QList<data_source::Telemetry*> TelemetryService::rootNodes() const
{
    QList<data_source::Telemetry*> list;

    list.append(d->vehicleNodes.values());
    list.append(&d->radioNode);

    return list;
}

data_source::Telemetry* TelemetryService::vehicleNode(int vehicleId) const
{
    return d->vehicleNodes.value(vehicleId, nullptr);
}

data_source::Telemetry* TelemetryService::mavNode(int mavId) const
{
    return this->vehicleNode(d->service->vehicleIdByMavId(mavId));
}

data_source::Telemetry* TelemetryService::radioNode() const
{
    return &d->radioNode;
}

void TelemetryService::onVehicleAdded(const dto::VehiclePtr& vehicle)
{
    if (d->vehicleNodes.contains(vehicle->id())) return;

    data_source::VehicleTelemetryFactory factory;
    d->vehicleNodes[vehicle->id()] = factory.create();
}

void TelemetryService::onVehicleRemoved(const dto::VehiclePtr& vehicle)
{
    if (!d->vehicleNodes.contains(vehicle->id())) return;

    // FIXME: crash on removing nodes
    //delete d->vehicleNodes[vehicle->id()];
}


