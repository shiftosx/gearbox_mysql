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

#import "MySQL.h"
#import "MySQLConnection.h"
#import "MySQLEditor.h"
#import "MySQLSchema.h"

@implementation MySQL

@synthesize mysqlConnection;

+ (NSString *) type{
	return @"MySQL";
}

+ (NSImage *) icon{
	NSString *imagePath = [[NSBundle bundleWithIdentifier:@"com.shiftosx.MySQL"] pathForResource:@"MySQL" ofType:@"icns"];
	return [[NSImage alloc] initByReferencingFile:imagePath];
}

- (NSBundle *)bundle
{
	return [NSBundle bundleWithIdentifier:@"com.shiftosx.MySQL"];
}

- (GBEditor *)editor
{
	if (editor == nil)
		editor = [[MySQLEditor alloc] initWithServer:self];
	return editor;
}

- (id)createConnection:(NSDictionary *)dictionary
{
	return [[MySQLConnection alloc] initWithDictionary:dictionary];
}

- (void)connect:(MySQLConnection *)aConnection
{	
	mysql_init(&mysqlConnection);
	mysql_options(&mysqlConnection, MYSQL_READ_DEFAULT_GROUP, "shift");
	if (mysql_real_connect(&mysqlConnection,
							[aConnection.host UTF8String],
							[aConnection.user UTF8String],
							[aConnection.password UTF8String],
							[aConnection.database UTF8String],0,NULL,0))
	{
		[super connect:aConnection];
		[self postNotification:GBNotificationConnected withInfo:nil];
	}else {
		[self postNotification:GBNotificationConnectionFailed withInfo:nil];
		NSLog(@"MySQL: Failed to connected. Error:%@\n", [self lastErrorMessage]);
	}
}

- (void) disconnect
{
	if (self.connected)
		mysql_close(&mysqlConnection);
	[super disconnect];
}

- (void) selectSchema:(GBSchema *)schema
{
	if (connected) {
		mysql_select_db(&mysqlConnection, [schema.name UTF8String]);
	}
}

- (NSArray *) schemas
{
	if (!self.connected)
		return nil;
	
	MYSQL_RES *result = mysql_list_dbs(&mysqlConnection, NULL);
	MYSQL_ROW row;
	unsigned long *lengths;
	NSMutableArray *array = [NSMutableArray array];
	
	while ((row = mysql_fetch_row(result)))
	{
		lengths = mysql_fetch_lengths(result);
		MySQLSchema *schema = [[MySQLSchema alloc] initWithServer:self];
		schema.name = [NSString stringWithFormat:@"%.*s", (int) lengths[0], row[0]];
		[array addObject:schema];
	}

	mysql_free_result(result);
	schemas = array;
	
	
	return schemas;
}


- (GBResultSet *) query:(NSString *)query
{
	return nil;
}

- (NSString *) lastErrorMessage
{
	return [NSString stringWithFormat:@"%s", mysql_error(&mysqlConnection)];
}

@end
