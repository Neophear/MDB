using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace MDB.AppCode
{
    public static class Globals
    {
        public static RandomPassword GetRandomPassword()
        {
            return new RandomPassword(1, -1, 1, 1, 0, 0, 1, 2);
        }

        public static bool CanUserWrite()
        {
            return Roles.IsUserInRole("Admin") || Roles.IsUserInRole("Write");
        }
    }
}