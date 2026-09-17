import type { IHashService } from "../../../core/application/repositories/services/hashService_repo.ts";
import bcrypt from "bcryptjs";

// data/services/bcrypt.service.ts
export class BcryptService implements IHashService {
    async hash(value: string) { return bcrypt.hash(value, 10); }
    async compare(value: string, hash: string) { return bcrypt.compare(value, hash); }
}
