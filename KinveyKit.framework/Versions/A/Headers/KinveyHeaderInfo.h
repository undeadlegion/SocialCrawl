//
//  KinveyHeaderInfo.h
//  KinveyKit
//
//  Created by Michael Katz on 10/11/12.
//  Copyright (c) 2012 Kinvey. All rights reserved.
//
// This software is licensed to you under the Kinvey terms of service located at
// http://www.kinvey.com/terms-of-use. By downloading, accessing and/or using this
// software, you hereby accept such terms of service  (and any agreement referenced
// therein) and agree that you have read, understand and agree to be bound by such
// terms of service and are of legal age to agree to such terms with Kinvey.
//
// This software contains valuable confidential and proprietary information of
// KINVEY, INC and is subject to applicable licensing agreements.
// Unauthorized reproduction, transmission or distribution of this file and its
// contents is a violation of applicable laws.
//

#ifndef KinveyKit_KinveyHeaderInfo_h
#define KinveyKit_KinveyHeaderInfo_h


#define KCS_DEPRECATED(message,version) __attribute__((deprecated(#message " Deprecated in: KinveyKit " #version ".")))

#define KCS_CONSTANT FOUNDATION_EXPORT NSString* const

#endif