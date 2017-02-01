#ifndef VEHICLE_H
#define VEHICLE_H

// Internal
#include "attitude.h"
#include "position.h"
#include "gps.h"
#include "power_system.h"
#include "mission.h"

namespace domain
{
    class Vehicle: public QObject // TODO: system hierarchy & properly vehicle domain-model
    {
        Q_OBJECT

        Q_PROPERTY(Type type READ type WRITE setType NOTIFY typeChanged)
        Q_PROPERTY(State state READ state WRITE setState NOTIFY stateChanged)
        Q_PROPERTY(bool armed READ isArmed WRITE setArmed NOTIFY armedChanged)

        Q_PROPERTY(Attitude attitude READ attitude WRITE setAttitude
                   NOTIFY attitudeChanged)
        Q_PROPERTY(Position position READ position WRITE setPosition
                   NOTIFY positionChanged)
        Q_PROPERTY(Position homePosition READ homePosition
                   WRITE setHomePosition NOTIFY homePositionChanged)
        Q_PROPERTY(Gps gps READ gps WRITE setGps NOTIFY gpsChanged)
        Q_PROPERTY(PowerSystem powerSystem READ powerSystem
                   WRITE setPowerSystem NOTIFY powerSystemChanged)

        Q_PROPERTY(float indicatedAirSpeed READ indicatedAirSpeed
                   WRITE setIndicatedAirSpeed NOTIFY indicatedAirSpeedChanged)
        Q_PROPERTY(float trueAirSpeed READ trueAirSpeed WRITE setTrueAirSpeed
                   NOTIFY trueAirSpeedChanged)
        Q_PROPERTY(float groundSpeed READ groundSpeed WRITE setGroundSpeed
                   NOTIFY groundSpeedChanged)
        Q_PROPERTY(float barometricAltitude READ barometricAltitude
                   WRITE setBarometricAltitude NOTIFY barometricAltitudeChanged)
        Q_PROPERTY(float barometricClimb READ barometricClimb
                   WRITE setBarometricClimb NOTIFY barometricClimbChanged)
        Q_PROPERTY(int heading READ heading WRITE setHeading
                   NOTIFY headingChanged)

    public:
        enum Type
        {
            UnknownType = 0,
            FixedWingAircraft
        };

        enum State
        {
            UnknownState = 0,
            Boot,
            Calibrating,
            Standby,
            Active,
            Critical,
            Emergency,
            PowerOff
        };

        Vehicle(uint8_t vehicleId, QObject* parent);
        ~Vehicle() override;

        uint8_t vehicleId() const;

        Type type() const;
        State state() const;
        bool isArmed() const;

        Attitude attitude() const;
        Position position() const;
        Position homePosition() const;
        Gps gps() const;
        PowerSystem powerSystem() const;

        float indicatedAirSpeed() const;
        float trueAirSpeed() const;
        float groundSpeed() const;
        float barometricAltitude() const;
        float barometricClimb() const;
        int heading() const;

        Mission* assignedMission() const;

    public slots:
        void setType(Type type);
        void setState(State state);
        void setArmed(bool armed);

        void setAttitude(const Attitude& attitude);
        void setPosition(const Position& position);
        void setHomePosition(const Position& homePosition);
        void setGps(const Gps& gps);
        void setPowerSystem(const PowerSystem& powerSystem);

        void setIndicatedAirSpeed(float indicatedAirSpeed);
        void setTrueAirSpeed(float trueAirSpeed);
        void setGroundSpeed(float groundSpeed);
        void setBarometricAltitude(float barometricAltitude);
        void setBarometricClimb(float barometricClimb);
        void setHeading(int heading);

        void assignMission(Mission* mission);
        void unassignMission();

    signals:
        void typeChanged(Type type);
        void stateChanged(State state);
        void armedChanged(bool armed);

        void attitudeChanged(Attitude attitude);
        void positionChanged(Position position);
        void homePositionChanged(Position homePosition);
        void gpsChanged(Gps gps);
        void powerSystemChanged(PowerSystem powerSystem);

        void indicatedAirSpeedChanged(float indicatedAirSpeed);
        void trueAirSpeedChanged(float trueAirSpeed);
        void groundSpeedChanged(float groundSpeed);
        void barometricAltitudeChanged(float barometricAltitude);
        void barometricClimbChanged(float barometricClimb);
        void headingChanged(int heading);

        void assignedMissionChanged(Mission* mission);

        void commandArm(bool arm);
        void commandSetHome(const Position& homePosition);

    private:
        uint8_t m_vehicleId;

        Type m_type;
        State m_state;
        bool m_armed;

        Attitude m_attitude;
        Position m_position;
        Position m_homePosition;
        Gps m_gps;
        PowerSystem m_powerSystem;

        float m_indicatedAirSpeed;
        float m_trueAirSpeed;
        float m_groundSpeed;
        float m_barometricAltitude;
        float m_barometricClimb;
        int m_heading;

        Mission* m_assignedMission;

        Q_ENUM(Type)
        Q_ENUM(State)
    };
}

#endif // VEHICLE_H
