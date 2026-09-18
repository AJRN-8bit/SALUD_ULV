import type { ITokenService } from "../../../core/application/repositories/services/tokenService_repo.ts";
import jwt from "jsonwebtoken";
export declare class JwtService implements ITokenService {
    generate(payload: object): Promise<string>;
    verify(token: string): Promise<string | jwt.JwtPayload>;
}
//# sourceMappingURL=tokenService.d.ts.map