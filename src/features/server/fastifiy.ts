// Express app initialization and configuration

import fastify from 'fastify';
// import env from 'dotenv';
import { authRoutes } from './routes/authRoutes.ts';
import { groupRoutes } from './routes/groupRoutes.ts';
import { anthroRoutes } from './routes/anthroRoutes.ts';
import { database } from '../external/mssql/config.ts'; 
// import { anthroRoutes } from './routes/anthroRoutes.ts';

// import userRouter from './routes/userRoutes.ts';
// import userRouter from '../routes/userRoutes.ts';
// import userRouter from '../routes/userRoutes.ts';

const server = fastify();

server.register(authRoutes, { prefix: '/auth' });
server.register(anthroRoutes, { prefix: '/anthropometric' });
server.register(groupRoutes, { prefix: '/groups' });

const port = Number(process.env.PORT) || 3080 || 3100;
const host = process.env.HOST || '127.0.0.1';

server.get('/status', async (request, reply) => {
            return {
                status: 'ok',
                // connectedDB: database.connected,
                // connectedUsers: ,
                timestamp: new Date().toISOString(),
            };
        });

const runAPI = async () => {
    try {
        await server.listen({ port: port, host: '0.0.0.0' });
        console.log(`API up and running q(≧▽≦q) on http://${host}:${port}`);

    } catch (error) {
        server.log.error(error);
        process.exit(1);
    }
}


export default runAPI;
