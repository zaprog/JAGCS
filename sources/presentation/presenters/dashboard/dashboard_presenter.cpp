#include "dashboard_presenter.h"

// Qt
#include <QVariant>
#include <QDebug>

// Internal
#include "vehicle.h"

#include "service_registry.h"
#include "vehicle_service.h"

#include "vehicle_dashboard_factory.h"

using namespace presentation;

class DashboardPresenter::Impl
{
public:
    domain::VehicleService* service = domain::ServiceRegistry::vehicleService();
    dao::VehiclePtr vehicle;
};

DashboardPresenter::DashboardPresenter(QObject* parent):
    BasePresenter(parent),
    d(new Impl())
{
    connect(d->service, &domain::VehicleService::vehicleChanged,
            [this](const dao::VehiclePtr& vehicle) {
        if (vehicle == d->vehicle) this->updateInstruments();
    });
}

DashboardPresenter::~DashboardPresenter()
{}

void DashboardPresenter::setVehicle(int id)
{
    d->vehicle = d->service->vehicle(id);

    this->updateInstruments();
}

void DashboardPresenter::updateInstruments()
{
    if (d->vehicle)
    {
        VehicleDashboardFactory f(d->vehicle);

        this->setViewProperty(PROPERTY(instruments), f.create());
    }
    else
    {
        this->setViewProperty(PROPERTY(instruments), QVariantList());
    }
}
