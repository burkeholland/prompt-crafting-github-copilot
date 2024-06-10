import './String';
import express, { Request, Response } from 'express';
import chalk from 'chalk';
import vehicleRouter from './routers/vehicleRouter';

const app = express();
const port = 3000;

app.use(express.static('public'));

app.use('/api/vehicles', vehicleRouter);

app.get('/', (req: Request, res: Response) => {
    res.sendFile('index.html', { root: __dirname });
});

app.listen(port, () => {
    console.log(chalk.blue(`Server is running on http://localhost:${port} 🚀`));
});