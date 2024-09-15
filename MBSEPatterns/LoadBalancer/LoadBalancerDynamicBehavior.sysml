package LoadBalancerDynamicBehavior {

    import LoadBalancerPattern::*;

    state def 'Load Balancer States' {
        state idle;
        state processing;
        state responding;

        transition 'idle-processing'
            first idle
            accept clientRequest.req
            do assignRequestToServer()
            then processing;

        transition 'processing-responding'
            first processing
            accept serverRequest.response
            then responding;

        transition 'responding-idle'
            first responding
            do sendResponseToClient()
            then idle;
    }

    state def 'Server States' {
        state idle;
        state processing;

        transition 'idle-processing'
            first idle
            accept requestIn.req
            do processRequest()
            then processing;

        transition 'processing-idle'
            first processing
            do sendResponse()
            then idle;
    }

    part loadBalancer : LoadBalancer {
        exhibit state 'loadBalancerStates' : 'Load Balancer States';
    }

    part servers[3] : Server {
        exhibit state 'serverStates' : 'Server States';
    }

    transition 'client-server-interaction' {
        first loadBalancer.loadBalancerStates.idle
        accept clientRequest.req
        if availableServerExists()
        do forwardRequestToServer()
        then servers[*].serverStates.processing;
    }

    action assignRequestToServer {
        doc /* Assigns the incoming client request to one of the available servers. */
    }

    action processRequest {
        doc /* Processes the request received by the server. */
    }

    action sendResponse {
        doc /* Sends the processed response back to the load balancer. */
    }

    action sendResponseToClient {
        doc /* Sends the response from the server to the client via the load balancer. */
    }

    action availableServerExists {
        out available: Boolean;
        doc /* Checks if any server is available for handling the request. */
    }

    action forwardRequestToServer {
        doc /* Forwards the client's request to an available server. */
    }
}