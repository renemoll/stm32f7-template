#ifndef DEMO_H
#define DEMO_H

#include <cinttypes>

class DemoInterface
{
public:
    virtual void update(uint32_t timestamp) = 0;
    virtual bool periodElapsed() const = 0;

protected:
    virtual ~DemoInterface() {}
};

class Demo : public DemoInterface
{
public:
    Demo(uint32_t period)
        : m_period(period)
    {}

    void update(uint32_t timestamp) override;
    [[ nodiscard ]] bool periodElapsed() const override { return m_elapsed; }
private:
    const uint32_t m_period = 0;
    uint32_t m_previous = 0;
    bool m_elapsed = false;
};

#endif