import type { FastifyInstance } from "fastify";
import { SaveAnthroUseCase } from "../../../core/application/usecases/anthropometric/saveAntrho_usecase.ts";
import AnthroRepo from "../../external/mssql/queries/anthro_repo.ts";
import { GetAllAnthroController, GetByUserCodeAnthroController, SaveAnthroController } from "../controllers/anthropController.ts";
import { GetAllAnthroUseCase } from "../../../core/application/usecases/anthropometric/getAllAnthro_usecase.ts";
import { GetByUserIDUseCase } from "../../../core/application/usecases/anthropometric/getByUserCode_usercase.ts";


const repository = new AnthroRepo;

const saveUseCase = new SaveAnthroUseCase(repository);
const getAllUseCase = new GetAllAnthroUseCase(repository);
const getByUserCodeCase = new GetByUserIDUseCase(repository);

const saveController = SaveAnthroController(saveUseCase);
const getAllController = GetAllAnthroController(getAllUseCase);
const getByUserCodeController = GetByUserCodeAnthroController(getByUserCodeCase);

export async function anthroRoutes(fastify: FastifyInstance ){
    fastify.post("/save", saveController);
    fastify.get("/get/all", getAllController);
    fastify.get("/get/:userCode", getByUserCodeController);
}