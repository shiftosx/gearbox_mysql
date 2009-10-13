/* 
 * Shift is the legal property of its developers, whose names are listed in the copyright file included
 * with this source distribution.
 * 
 * This program is free software; you can redistribute it and/or modify it under the terms of the GNU
 * General Public License as published by the Free Software Foundation; either version 3 of the License,
 * or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program; if not,
 * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA 
 * or see <http://www.gnu.org/licenses/>.
 */

#import "../mysql/include/mysql.h"
#import "MySQLSchema.h"
#import "MySQL.h"

@implementation MySQLSchema

@synthesize server;

- (NSArray *) supportedFeatures
{
	return [NSArray arrayWithObjects:GBFeatureTable, GBFeatureView, GBFeatureStoredProcedure, GBFeatureFunction, GBFeatureTrigger, nil];
}

- (NSArray *) tables
{
	if (!server.connected)
		return nil;
	MYSQL mysqlConnection = server.mysqlConnection;
	MYSQL_RES *result = mysql_list_tables(&mysqlConnection, NULL);
	MYSQL_ROW row;
	unsigned long *lengths;
	NSMutableArray *array = [NSMutableArray array];

	while ((row = mysql_fetch_row(result)))
	{
		lengths = mysql_fetch_lengths(result);
		GBTable *table = [[GBTable alloc] init];
		table.name = [NSString stringWithFormat:@"%.*s", (int) lengths[0], row[0]];
		[array addObject:table];
	}

	tables = array;
	mysql_free_result(result);
	
	return tables;
}

- (NSArray *)views
{
//NSString *query = [NSString stringWithFormat:@"SELECT table_name FROM information_schema.views WHERE table_schema = '%@';", self.name];
	return nil;
}

- (NSArray *)storedProcedures
{
//NSString *query = [NSString stringWithFormat:@"SELECT routine_name FROM information_schema.routines WHERE routine_schema = '%@' AND routine_type = 'FUNCTION';", self.name];
	return nil;
}

- (NSArray *)functions
{
//NSString *query = [NSString stringWithFormat:@"SELECT routine_name FROM information_schema.routines WHERE routine_schema = '%@' AND routine_type = 'FUNCTION';", self.name];
	return nil;
}

- (NSArray *)triggers
{
//NSString *query = [NSString stringWithFormat:@"SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema = '%@';", self.name];
	return nil;
}

@end
