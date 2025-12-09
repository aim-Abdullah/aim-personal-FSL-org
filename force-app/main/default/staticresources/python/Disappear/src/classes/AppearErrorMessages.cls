public class AppearErrorMessages {

	public final static string ProductIndicationIsMandatory = 
		'Product Indication is a mandatory field. Please select one.';

	public final static string SelectValidPrimaryProductIndication = 
		'Please select a PRIMARY Product Indication';
		
	public final static string NeedAttachmentName = 
		'Please enter a name for this attachment';
		
	public final static string NeedAttachmentType = 
		'Please select a type for this attachment';
		
	public final static string NeedNewPublicationTeamMember = 
		'Cannot create New Publication Team Member record.  Please select a Team Member first';

	public final static string NeedRoleForNewPublicationTeamMember = 
		'Cannot create New Publication Team Member record. Please select a Role';

	public final static string NeedNewPreFprReviewer = 
		'Cannot create New Pre FPR Reviewer record.  Please select a Team Member first';

	public final static string NeedRoleForNewPreFprReviewer = 
		'Cannot create New Pre FPR Reviewer record. Please select a Role';

	public final static string NeedRelatedPubToSave = 
		'Please Choose a Publication to Relate';		
		
	public final static string CloneInvalidSourcePub = 
		'Invalid Source Publication.  Cannot clone - please contact System Admin';
	
	public final static string RestrictCloneFunctionality = 
  		'Cannot clone - You do not have access to mentioned Publications : ';	
    
    //Appear Enhancement R1:2017 - Error message for FPRC users while adding Author limit justification.
    public final static string RestrictAuthorLimitJustificationAdd = 
  		'Cannot Add Author Limit Justification Attachment - You do not have permission. Please Contact Business Admin.';
		
	public static void Coverage() {
		System.Debug(AppearErrorMessages.ProductIndicationIsMandatory);
	}
}