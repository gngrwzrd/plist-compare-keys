
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
	
	@autoreleasepool {
		char buf[2048];
		char * buf2 = getcwd(buf,sizeof(buf));
		if(!buf2) {
			NSLog(@"error getting cwd");
			exit(1);
		}

		#if !DEBUG
		NSURL * cwd = [NSURL fileURLWithPath:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]];
		NSArray * arguments = [[NSProcessInfo processInfo] arguments];
		if(arguments.count < 2) {
			NSLog(@"usage: PlistCompareKeys plist1.plist plist2.plist");
			exit(1);
		}
		#endif
		
		#if !DEBUG
		NSString * plist1Name = [arguments objectAtIndex:1];
		NSURL * plist1File = [NSURL URLWithString:plist1Name relativeToURL:cwd];
		#else
		NSString * plist1Name = @"CUR8/Documentr-Info.plist";
		NSURL * plist1File = [NSURL URLWithString:plist1Name relativeToURL:[NSURL fileURLWithPath:@"/Users/aaronsmith/Development/Apptitude/documentr/Documentr/Resources"]];
		#endif
		NSDictionary * plist1 = [NSDictionary dictionaryWithContentsOfFile:plist1File.path];
		
		#if !DEBUG
		NSString * plist2Name = [arguments objectAtIndex:2];
		NSURL * plist2File = [NSURL URLWithString:plist2Name relativeToURL:cwd];
		#else
		NSString * plist2Name = @"DocumntrGeneric/Documentr-Info.plist";
		NSURL * plist2File = [NSURL URLWithString:plist2Name relativeToURL:[NSURL fileURLWithPath:@"/Users/aaronsmith/Development/Apptitude/documentr/Documentr/Resources"]];
		#endif
		NSDictionary * plist2 = [NSDictionary dictionaryWithContentsOfFile:plist2File.path];
		
		for(NSString * key in plist1) {
			if(![plist2 objectForKey:key]) {
				NSLog(@"%@: in (plist1: %@), NOT in (plist2: %@)",key,plist1Name,plist2Name);
			}
		}
		
		BOOL logsplit = FALSE;
		for(NSString * key in plist2) {
			if(![plist1 objectForKey:key]) {
				if(!logsplit) {
					NSLog(@"=====");
					logsplit = TRUE;
				}
				NSLog(@"%@: in %@, NOT in %@",key,plist2Name,plist1Name);
			}
		}
	}
    
	return 0;
}

