package LoadBalancerUseCases {

    // Definición de los actores
    actor Client;
    actor Server;

    // Caso de uso principal: Balanceo de carga
    usecase BalanceLoad {
        doc /* Este caso de uso describe cómo el Load Balancer distribuye las solicitudes entrantes de los clientes entre los servidores disponibles para su procesamiento. */
        
        subject: LoadBalancer;
        actor: Client, Server;
    }
    
    // Caso de uso 1: Enviar Solicitud
    usecase SendRequest {
        doc /* El cliente envía una solicitud al Load Balancer para ser procesada por uno de los servidores. */
        
        subject: Client;
        actor: LoadBalancer;
    }

    // Caso de uso 2: Procesar Solicitud
    usecase ProcessRequest {
        doc /* El Load Balancer selecciona un servidor y envía la solicitud para su procesamiento. */
        
        subject: LoadBalancer;
        actor: Server;
    }
    
    // Caso de uso 3: Retornar Respuesta
    usecase ReturnResponse {
        doc /* El servidor procesa la solicitud y envía una respuesta de vuelta al cliente a través del Load Balancer. */
        
        subject: Server;
        actor: LoadBalancer, Client;
    }

    // Relaciones entre casos de uso
    usecase BalanceLoad {
        include SendRequest;
        include ProcessRequest;
        include ReturnResponse;
    }

    // Contexto del sistema: Interacción entre actores y casos de uso
    part LoadBalancerSystemContext {
        actor client1: Client;
        actor server1: Server;
        part loadBalancer: LoadBalancer;
        
        exhibit usecase BalanceLoad {
            include SendRequest;
            include ProcessRequest;
            include ReturnResponse;
        }
    }
}