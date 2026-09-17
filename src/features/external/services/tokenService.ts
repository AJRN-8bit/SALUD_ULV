import type { ITokenService } from "../../../core/application/repositories/services/tokenService_repo.ts";
import env from 'dotenv';
import jwt from "jsonwebtoken";

export class JwtService implements ITokenService {
    async generate(payload: object) { return jwt.sign(payload, "secret", {expiresIn: "7d"}); }
    async verify(token: string) { return jwt.verify(token, "secret"); }
}