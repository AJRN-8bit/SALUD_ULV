import type { IHashService } from "../../../core/application/repositories/services/hashService_repo.ts";
export declare class BcryptService implements IHashService {
    hash(value: string): Promise<string>;
    compare(value: string, hash: string): Promise<boolean>;
}
//# sourceMappingURL=hashService.d.ts.map