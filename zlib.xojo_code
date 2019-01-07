#tag Module
Protected Module zlib
	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function e_uncompress Lib zlibPath Alias "uncompress" (Output As Ptr, ByRef OutLen As UInt64, Source As Cstring, SourceLen As UInt64) As Integer
	#tag EndExternalMethod

	#tag Method, Flags = &h0
		Function Version() As String
		  soft declare function zlibVersion lib zlibPath () as Ptr
		  
		  dim p as MemoryBlock = zlibVersion
		  if p <> nil then
		    return p.CString(0)
		  else
		    return ""
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function zlibCompress(input as String) As String
		  pLastErrorCode = 0
		  
		  soft declare function zlibcompress lib zlibPath alias "compress" (dest as Ptr, ByRef destLen as Uint32, source as CString, sourceLen as UInt32) as Integer
		  
		  dim output as new MemoryBlock(12 + 1.002*LenB(input))
		  dim outputSize as UInt32 = output.Size
		  
		  pLastErrorCode = zlibcompress(output, outputSize, input, LenB(input))
		  if pLastErrorCode = 0 then
		    dim stringResult as String = output.StringValue(0, outputSize)
		    return stringResult.Mid(3).LeftB(stringResult.LenB - 4)
		  else
		    return ""
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function zlibUncompress(input as String, bufferSize as Integer = 0) As String
		  pLastErrorCode = 0
		  
		  input = chrB(HEADER_1) + chrB(HEADER_2) + input
		  
		  if bufferSize = 0 then
		    bufferSize = 4*LenB(input)
		  end if
		  
		  
		  do
		    
		    dim m as new MemoryBlock(bufferSize)
		    dim destLength as UInt64 = m.Size
		    Dim cs As CString = input
		    
		    'MsgBox "zlib : " + System.IsFunctionAvailable("zlibVersion", zlibPath).StringValue
		    pLastErrorCode = e_uncompress(m, destLength, CS , LenB(input))
		    
		    
		    
		    if pLastErrorCode = 0 then
		      return m.StringValue(0, destLength)
		    elseIf pLastErrorCode = Z_BUF_ERROR then
		      bufferSize = bufferSize + bufferSize
		    else
		      return m.StringValue(0, destLength)
		    end if
		    
		  loop
		  
		  Exception err as FunctionNotFoundException
		    MsgBox err.message + "Error No.:" + str(err.ErrorNumber)
		End Function
	#tag EndMethod


	#tag Note, Name = Documentation
		
		zlib
		3/22/2007
		charles@declareSub.com
		http://www.declareSub.com
		
		
		zlib is a wrapper for the zlib compression library, available on Mac OS X, Linux, and Windows.
		It currently consists of a module, zlib, and a class, gzipStream.  Documentation for gzipStream
		can be found in the class.
		
		zlib is compatible with gzipped files, but not zipped files.
		--------------------------------------------------------
		
		Module zlib
		
		zlibCompress and zlibUncompress provide in-memory compression of
		REALbasic strings.
		
		Using zlibCompress is simple.
		
		dim output as String = zlibCompress(input)
		
		Using zlibUncompress is slightly more complicated.  The length of the uncompressed
		string is not stored in the compressed string.  zlibUncompress uses a simple strategy to
		guess the amount of buffer space needed to uncompress the input.  If you happen to know the
		size of the uncompressed data in bytes, you can pass it to zlibUncompress in the optional second 
		parameter to possibly speed things up a bit.
		
		dim output as String = zlibUncompress(input)
		dim output as String = zlibUncompress(input, 740526)
		
		The Version function returns the version of zlib.
		
		LastErrorCode contains the last error code returned by a zlib function.
		
		Error codes for zlibCompress:  Z_OK = no error, Z_MEM_ERROR = not enough memory, Z_BUF_ERROR = buffer too small.
		
		Error codes fror zlibUncompress: Z_OK = no error, Z_MEM_ERROR = not enough memory, Z_DATA_ERROR = corrupted data.
		
		Xojo 2015 change the Resource folder location on windows... make sur your zlib1.dll is reachable
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return pLastErrorCode
			End Get
		#tag EndGetter
		LastErrorCode As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private pLastErrorCode As Integer
	#tag EndProperty


	#tag Constant, Name = HEADER_1, Type = Double, Dynamic = False, Default = \"&h78", Scope = Public
	#tag EndConstant

	#tag Constant, Name = HEADER_2, Type = Double, Dynamic = False, Default = \"&h9C", Scope = Public
	#tag EndConstant

	#tag Constant, Name = zlibPath, Type = String, Dynamic = False, Default = \"", Scope = Private
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"/usr/lib/libz.dylib"
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"Libraries/zlib1.dll"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"/usr/lib/libz.so.1"
	#tag EndConstant

	#tag Constant, Name = Z_BUF_ERROR, Type = Double, Dynamic = False, Default = \"-5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_DATA_ERROR, Type = Double, Dynamic = False, Default = \"-3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_ERRNO, Type = Double, Dynamic = False, Default = \"-1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_MEM_ERROR, Type = Double, Dynamic = False, Default = \"-4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_OK, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_STREAM_ERROR, Type = Double, Dynamic = False, Default = \"-2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Z_VERSION_ERROR, Type = Double, Dynamic = False, Default = \"-6", Scope = Public
	#tag EndConstant


	#tag Structure, Name = z_stream, Flags = &h21, Attributes = \"StructureAlignment \x3D 1"
		next_in as Ptr
		  avail_in as UInt32
		  total_in as UInt32
		  next_out as Ptr
		  avail_out as UInt32
		  total_out as UInt32
		  msg as Ptr
		  internal_state as Ptr
		  zalloc as Ptr
		  zfree as Ptr
		  opaque as Ptr
		  data_type as Int32
		  adler as UInt32
		reserved as UInt32
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
