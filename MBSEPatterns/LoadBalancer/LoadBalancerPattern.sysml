package LoadBalancerPattern {

    // Define the components of the system
    part def Client;
    part def Server {
        port requestIn: RequestPort;
        attribute serverID: String;
    }
    
    part def LoadBalancer {
        port clientRequest: RequestPort;
        port serverRequest[0..*]: RequestPort;
    }
    
    port def RequestPort {
        in req: Request;
        out response: Response;
    }
    
    item def Request {
        attribute requestID: String;
        attribute payload: String;
    }
    
    item def Response {
        attribute responseID: String;
        attribute result: String;
    }
    
    // Context to connect the components
    part loadBalancerContext {
        part client1: Client;
        part loadBalancer: LoadBalancer;
        part servers[3]: Server {
            attribute redefines serverID = "Server#" + (this.index + 1);
        }

        // Flow from client to load balancer
        interface clientToLB connect client1.requestOut to loadBalancer.clientRequest {
            flow from source.req to target.req;
        }

        // Load balancer distributes requests to servers
        interface lbToServers connect loadBalancer.serverRequest to servers[*].requestIn {
            flow from source.req to target.req;
        }

        // Responses flow back from servers to load balancer to client
        flow serverResponseFlow from servers[*].requestIn.response to loadBalancer.clientRequest.response;
    }
}