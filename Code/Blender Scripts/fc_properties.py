# FC Object properties dialog

import bpy

class OBJECT_PT_fc(bpy.types.Panel):
    bl_space_type = 'PROPERTIES'
    bl_region_type = 'WINDOW'
    bl_context = "object"
    bl_label = "FC Properties"
    
    def draw(self, context):
        layout = self.layout
        obj = context.object
        
        row = layout.row()
        row.prop(obj, "fc_object_type", "Type")
        
        # now detail row
        
        fctype = obj.fc_object_type
        
        if fctype == 'None':
            print("None")
        elif fctype == 'Locator':
            print("Locator")
        elif fctype == 'Actor':
            row = layout.row()
            row.prop(obj, "fc_actor_dynamic", "Dynamic")
        elif fctype == 'Model':
            row = layout.row()
            row.prop(obj, "fc_shader_type", "Shader")
        else:
            row = layout.row()
            row.prop(obj, "fc_fixture_type", "Fixture Type")
        

if __name__ == "__main__":
    FCObjectTypes = [("None", "None", "None"), ("Locator", "Locator", "Locator"), ("Actor", "Actor", "Actor"), ("Fixture", "Fixture", "Fixture"), ("Model", "Model", "Model")]
    bpy.types.Object.fc_object_type = bpy.props.EnumProperty( items = FCObjectTypes, name = "FC Type", description = "FC Type", default = "None")
    
    FCFixtureTypes = [("Circle", "Circle", "Circle"), ("Box", "Box", "Box"), ("Hull", "Hull", "Hull")]
    bpy.types.Object.fc_fixture_type = bpy.props.EnumProperty( items=FCFixtureTypes, name="FixtureType", description="Fixture Type", default="Hull" )
    
    FCShaderTypes = [("Debug", "Debug", "Debug"), ("Simple", "Simple", "Simple")]
    bpy.types.Object.fc_shader_type = bpy.props.EnumProperty( items=FCShaderTypes, name="ShaderType", description="Shader", default="Debug" )
    
    bpy.types.Object.fc_actor_dynamic = bpy.props.BoolProperty( name="Dynamic", description="Dynamic, moving actor" )
    
    bpy.utils.register_class(OBJECT_PT_fc)
    