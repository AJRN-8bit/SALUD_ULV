import app from "./features/server/config/express.ts";

async function main() {
    try {
        const port = process.env.PORT || 3010;
        const host = process.env.HOST || 'localhost';
    
        app.listen(port, () => {
            console.log(`API up and running q(≧▽≦q) on http://${host}:${port}/api/v1`);
        });   
    } catch (error) {
        throw new Error(`${error}`);
    }
}

main();