import { DatabaseService as databaseService } from "../services/index.js";

const controller = {
  sync: async (req, res) => {
    try {
      await databaseService.sync(req, res);
      res.status(200).json({ message: "Database sync was done successfully." });
    } catch (err) {
      const errorMessage = `Error while trying to sync the database: ${err.message}.`;
      console.error(errorMessage);
      res.status(500).json({ message: errorMessage });
    }
  },
};

export default controller;