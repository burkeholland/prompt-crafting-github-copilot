import express from 'express';
import { getAllVehicles } from '../controllers/vehicleController';

const vehicleRouter = express.Router();

vehicleRouter.get('/', getAllVehicles);

export default vehicleRouter;