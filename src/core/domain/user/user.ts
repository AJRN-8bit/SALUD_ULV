// User structure
import bcrypt from 'bcryptjs';

export class User {
        public readonly userID: number;
        public readonly name: string;
        public readonly firstName: string; 
        public readonly lastName: string; 
        public readonly email: string; 
        private password: string; 
        public readonly birthDate: Date; 
        public readonly age: number; 
        public readonly gender: string;
        public readonly createdAt: Date;

    constructor(
        userID: number, 
        name: string, 
        firstName: string, 
        lastName: string, 
        email: string, 
        password: string, 
        birthDate: Date, 
        age: number, 
        gender: string,
        createdAt: Date
    ){

        this.userID = userID;
        this.name = name;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.birthDate = birthDate;
        this.age = age;
        this.gender = gender;
        this.createdAt = createdAt;
        }

    getPassword(): string{
        return this.password;
    }

    static async validateUserID(userID: number): Promise<boolean>{
        return (userID.toString().length <= 6 && /[0-9]/.test(userID.toString()));
    }

    // Password validation. The password must contain at least 8 characters, one number and one letter.
    static async validatePassword(password: string): Promise<Boolean>{
        return (password.length >= 8 && /[a-zA-Z]/.test(password) && /[0-9]/.test(password));
    }
    
    // Email validation
    static async validateEmail(email: string): Promise<boolean>{
        const pattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
        return pattern.test(email);
    }

    // Password hashing
    static async hashPassword(password: string): Promise<string>{
        const salt = await bcrypt.genSalt(10);
        return bcrypt.hash(password, salt);
    }

    // Compares the password with the hashed password
    public static async comparePassword(password: string, hashedPassword: string): Promise<Boolean>{
        return bcrypt.compare(password, hashedPassword);
    }

    // const token = jwt.sign({userID: userFound._id}, "passwordKey");
    //         const {password, ...userWithoutPassword} = userFound._doc; 
}



export interface ICreateUserRequest{
    userID: number;
    name: string;
    email: string;
    age: number;
}

// User registry structure
export interface IUserRegistry{
    userID: number;
    email: string;
    password: string;
}

export interface IUserInfoRegistry{
    userID: number;
    name: string;
    firstName: string; 
    lastName: string; 
    birthDate: Date; 
    age: number; 
    gender: string;
}

export interface IUserLogin {
    email: string;
    password: string;
}


