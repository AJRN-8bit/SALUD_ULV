import express from 'express';
import userRoutes from '../routes/express/userRoutes.ts';
import adminRoutes from '../routes/express/adminRoutes.ts';

// 
const app = express();

app.use(express.json());

// app.use("/api/v1", userRoutes);
userRoutes(app);
adminRoutes(app);

export default app;