import GetUserProfile from "./getUserProfile.ts";
import RegisterUserAnthropometricData from "./registerAnthData.ts"; "./registerAnthData.ts";
import GetUserAntrophometricData from "./getAllAnthData.ts";
import RegisterUserActivity from "./registerActivity.ts";
import GetUserActivities from "./getAllActivities.ts";
import DeleteUserActivity from "./deleteActivity.ts";


export {
    GetUserProfile,
    RegisterUserAnthropometricData,
    GetUserAntrophometricData as GetAllUserAntrophometricData,
    RegisterUserActivity,
    GetUserActivities as GetAllUserActivities,
    DeleteUserActivity,
};