/**
 * MyTestNetworkC exercises the basic networking layers, collection and
 * dissemination. The application samples DemoSensorC at a basic rate
 * and sends packets up a collection tree. The rate is configurable
 * through dissemination.
 *
 * See TEP118: Dissemination, TEP 119: Collection, and TEP 123: The
 * Collection Tree Protocol for details.
 * 
 * @author Philip Levis
 * @version $Revision: 1.6 $ $Date: 2007/09/14 18:48:51 $
 */
#include "MyTestNetwork.h"
#include "Ctp.h"

configuration MyTestNetworkAppC {}
implementation {
  components MyTestNetworkC, MainC, LedsC, ActiveMessageC;
  components DisseminationC;
  components new DisseminatorC(uint16_t, SAMPLE_RATE_KEY) as Object16C;
  components CollectionC as Collector;
  components new CollectionSenderC(CL_TEST);
  components new TimerMilliC();
  components new DemoSensorC();
  components new SerialAMSenderC(CL_TEST);
  components SerialActiveMessageC;
#ifndef NO_DEBUG
  components new SerialAMSenderC(AM_COLLECTION_DEBUG) as UARTSender;
  components UARTDebugSenderP as DebugSender;
#endif
  components RandomC;
  components new QueueC(message_t*, 12);
  components new PoolC(message_t, 12);

  MyTestNetworkC.Boot -> MainC;
  MyTestNetworkC.RadioControl -> ActiveMessageC;
  MyTestNetworkC.SerialControl -> SerialActiveMessageC;
  MyTestNetworkC.RoutingControl -> Collector;
  MyTestNetworkC.DisseminationControl -> DisseminationC;
  MyTestNetworkC.Leds -> LedsC;
  MyTestNetworkC.Timer -> TimerMilliC;
  MyTestNetworkC.DisseminationPeriod -> Object16C;
  MyTestNetworkC.Send -> CollectionSenderC;
  MyTestNetworkC.ReadSensor -> DemoSensorC;
  MyTestNetworkC.RootControl -> Collector;
  MyTestNetworkC.Receive -> Collector.Receive[CL_TEST];
  MyTestNetworkC.UARTSend -> SerialAMSenderC.AMSend;
  MyTestNetworkC.CollectionPacket -> Collector;
  MyTestNetworkC.CtpInfo -> Collector;
  MyTestNetworkC.CtpCongestion -> Collector;
  MyTestNetworkC.Random -> RandomC;
  MyTestNetworkC.Pool -> PoolC;
  MyTestNetworkC.Queue -> QueueC;
  MyTestNetworkC.RadioPacket -> ActiveMessageC;
  
#ifndef NO_DEBUG
  components new PoolC(message_t, 10) as DebugMessagePool;
  components new QueueC(message_t*, 10) as DebugSendQueue;
  DebugSender.Boot -> MainC;
  DebugSender.UARTSend -> UARTSender;
  DebugSender.MessagePool -> DebugMessagePool;
  DebugSender.SendQueue -> DebugSendQueue;
  Collector.CollectionDebug -> DebugSender;
  MyTestNetworkC.CollectionDebug -> DebugSender;
#endif
  MyTestNetworkC.AMPacket -> ActiveMessageC;
}
