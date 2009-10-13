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

#import "MySQLEditor.h"
#import "MySQLConnection.h"


@implementation MySQLEditor

- (MySQLConnection *)connection
{
	if (connection == nil)
		connection = [[MySQLConnection alloc] init];
	
	// Validate requirements
	// Would be nice to add in a check for valid connection and pop up a notice if it fails, a'la apple mail
	[nameWarning setHidden:![[name stringValue] isEqualToString:@""]];
	[hostWarning setHidden:![[host stringValue] isEqualToString:@""]];
	[userWarning setHidden:![[user stringValue] isEqualToString:@""]];
	
	if ([[name stringValue] isEqualToString:@""] || [[host stringValue] isEqualToString:@""] || [[user stringValue] isEqualToString:@""]){
		return nil;
	}
	
	connection.name = [name stringValue];
	connection.host = [host stringValue];
	connection.user = [user stringValue];
	connection.password = [password stringValue];
	connection.database = [database stringValue];
	connection.socket = [socket stringValue];
	if ([port intValue] > 0)
		connection.port = [NSNumber numberWithInt:[port intValue]];
	
	return connection;
}


- (void) setConnection:(MySQLConnection *)aConnection
{
	connection = aConnection;
	NSString *nameString = (connection.name) ? connection.name : @"";
	NSString *hostString = (connection.host) ? connection.host : @"";
	NSString *userString = (connection.user) ? connection.user : @"";
	NSString *passwordString = (connection.password) ? connection.password : @"";
	NSString *databaseString = (connection.database) ? connection.database : @"";
	NSString *socketString = (connection.socket) ? connection.socket : @"";
	
	[name setStringValue:nameString];
	[host setStringValue:hostString];
	[user setStringValue:userString];
	[password setStringValue:passwordString];
	[database setStringValue:databaseString];
	[socket setStringValue:socketString];
	if ([connection.port intValue] > 0)
		[port setIntValue:[aConnection.port intValue]];
}

@end
