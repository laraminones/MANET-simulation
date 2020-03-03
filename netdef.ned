package inet.examples.Practica4;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.aodv.AodvRouter;
import inet.node.inet.AdhocHost;
import inet.node.inet.ManetRouter;
import inet.node.inet.StandardHost;
import inet.physicallayer.unitdisk.UnitDiskRadioMedium;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;
import inet.visualizer.linklayer.DataLinkVisualizer;


network manets
{
    parameters:
        int n;
        @display("bgb=969.52795,630.432");
    submodules:
        radioMedium: UnitDiskRadioMedium {
            parameters:
                @display("p=313.91998,30.084;is=s");
        }
        visualizer: IntegratedCanvasVisualizer {
            @display("p=31.392,176.58");
        }
        configurator: Ipv4NetworkConfigurator {
            parameters:
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=31.392,30.084;is=s");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=159.576,57.552;is=s");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=45.78,99.408;is=s");
        }
        nodoFijo1: ManetRouter {
            @display("p=71.939995,336.156;i=device/pc2");
        }
        nodoFijo2: ManetRouter {
            @display("p=767.79596,337;i=device/pc2");
        }
        nodoMovil[n]: ManetRouter {
            @display("p=414.318,335.514");
        }
    connections allowunconnected:
}
