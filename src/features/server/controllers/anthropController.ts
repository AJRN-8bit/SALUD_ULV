// import type { Request, Response, NextFunction} from "express";
// import type { IRegisterAnthropometricOutPort } from "../../../../../core/userAnthropometric/ports/secondary/anthtopometricOutPorts.ts";
// import SQLRepository from "../../../out/repositories/mssql/queries/userAuthRepository.ts";
// import RegisterUserAnthropometricData from "../../../../../core/userAnthropometric/usecases/registerAnthData.ts";
// import AnthropometricSQLRepository from "../../../out/repositories/mssql/queries/userAnthropRepository.ts";

import type { FastifyRequest, FastifyReply } from 'fastify';
import type { IGetAllDataUseCase, IGetByUserIDUseCase, ISaveAnthroUseCase } from "../../../core/application/repositories/use-cases/anthro_usecases.ts";
import { AnthropometricDto } from '../../DTOs/anthropometicDto.ts';
import { request } from 'node:http';

// const repository = AnthropometricSQLRepository;



export const SaveAnthroController = (useCase: ISaveAnthroUseCase) => {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const body = request.body as any;
      const data = AnthropometricDto.fromJson(body).toDomain();
    
      // console.log(`Data received: ${data.userUUID}`);
      await useCase.execute(data);

      return reply.status(201).send({
        message: "Anthropometric data added successfully"
      });

    } catch (error) {
      return reply.status(500).send({
        error: error instanceof Error ? error.message : "Internal Server Error"
      });
    }
  };
};




export const GetAllAnthroController = (useCase: IGetAllDataUseCase) => {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    try {

      const result = await useCase.execute();
      const data = result?.map(item => AnthropometricDto.fromDomain(item).toJson());

      console.log(`In controller: ${data?.toString()}`);

      return reply.status(200).send({
        message: "Anthropometric Data",
        data: data
      });

    } catch (error) {
      return reply.status(500).send({
        error: error instanceof Error ? error.message : "Internal Server Error"
      });
    }
  };
};



export const GetByUserCodeAnthroController = (useCase: IGetByUserIDUseCase) => {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    try {
      const {userCode} = request.params as {userCode: string};
      

      const result = await useCase.execute(userCode);
      const data = result?.map(item => AnthropometricDto.fromDomain(item).toJson());

      console.log(`In controller: ${data?.toString()}`);

      return reply.status(200).send({
        message: "Anthropometric Data",
        data: data
      });

    } catch (error) {
      return reply.status(500).send({
        error: error instanceof Error ? error.message : "Internal Server Error"
      });
    }
  };
};
