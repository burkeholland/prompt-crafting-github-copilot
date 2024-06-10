import { Request, Response } from 'express';
import { query } from '../data/db';

/**
 * Retrieves all vehicles from the database.
 * 
 * @param req - The request object.
 * @param res - The response object.
 * @returns A JSON response containing the retrieved vehicles.
 */
export const getAllVehicles = async (req: Request, res: Response) => {
    try {
        const result = await query('SELECT * FROM vehicles LIMIT 10', []);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'An error occurred while fetching vehicles' });
    }
};