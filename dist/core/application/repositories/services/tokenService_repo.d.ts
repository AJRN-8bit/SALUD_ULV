export interface ITokenService {
    generate(payload: object): Promise<string>;
    verify(token: string): Promise<string | object | null>;
}
//# sourceMappingURL=tokenService_repo.d.ts.map