//===-- FeatureList.cpp ---------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// A plugin that counts the amount of times a particular parse tree node
// occurs.  This plugin should cover each feature covered in dump-parse-tree.h
//
//===----------------------------------------------------------------------===//

#include "flang/Frontend/FrontendActions.h"
#include "flang/Frontend/FrontendPluginRegistry.h"
#include "flang/Parser/parse-tree-visitor.h"
#include "flang/Parser/parse-tree.h"
#include "flang/Parser/parsing.h"

#include <algorithm>
#include <cstring>
#include <unordered_map>
#include <utility>
#include <vector>

using namespace Fortran::frontend;
using namespace Fortran::parser;
using namespace Fortran;

#define READ_FEATURE_CUST(classname, n) \
  bool Pre(const classname &) { \
    record(#n); \
    return true; \
  } \
  void Post(const classname &) {}

#define READ_FEATURE(classname) READ_FEATURE_CUST(classname, classname)

struct NodeVisitor {
private:
  std::unordered_map<const char *, unsigned int> frequencies;

  void record(const char *name) {
    auto [it, ins] = frequencies.insert({name, 1});
    if (!ins) {
      it->second++;
    }
  }

public:
  const std::unordered_map<const char *, unsigned int> &getFrequencies() const {
    return frequencies;
  }

  READ_FEATURE_CUST(format::ControlEditDesc, ControlEditDesc)
  READ_FEATURE_CUST(format::DerivedTypeDataEditDesc, DerivedTypeDataEditDesc)
  READ_FEATURE_CUST(format::FormatItem, FormatItem)
  READ_FEATURE_CUST(format::FormatSpecification, FormatSpecification)
  READ_FEATURE_CUST(
      format::IntrinsicTypeDataEditDesc, IntrinsicTypeDataEditDesc)
  READ_FEATURE(Abstract)
  READ_FEATURE(AccAtomicCapture)
  READ_FEATURE(AccAtomicCapture::Stmt1)
  READ_FEATURE(AccAtomicCapture::Stmt2)
  READ_FEATURE(AccAtomicRead)
  READ_FEATURE(AccAtomicUpdate)
  READ_FEATURE(AccAtomicWrite)
  READ_FEATURE(AccBeginBlockDirective)
  READ_FEATURE(AccBeginCombinedDirective)
  READ_FEATURE(AccBeginLoopDirective)
  READ_FEATURE(AccBlockDirective)
  READ_FEATURE(AccClause)
  READ_FEATURE(AccBindClause)
  READ_FEATURE(AccDefaultClause)
  READ_FEATURE(AccClauseList)
  READ_FEATURE(AccCombinedDirective)
  READ_FEATURE(AccDataModifier)
  READ_FEATURE(AccDataModifier::Modifier)
  READ_FEATURE(AccDeclarativeDirective)
  READ_FEATURE(AccEndAtomic)
  READ_FEATURE(AccEndBlockDirective)
  READ_FEATURE(AccEndCombinedDirective)
  READ_FEATURE(AccGangArg)
  READ_FEATURE(AccObject)
  READ_FEATURE(AccObjectList)
  READ_FEATURE(AccObjectListWithModifier)
  READ_FEATURE(AccObjectListWithReduction)
  READ_FEATURE(AccReductionOperator)
  READ_FEATURE(AccReductionOperator::Operator)
  READ_FEATURE(AccSizeExpr)
  READ_FEATURE(AccSizeExprList)
  READ_FEATURE(AccSelfClause)
  READ_FEATURE(AccStandaloneDirective)
  READ_FEATURE(AccDeviceTypeExpr)
  READ_FEATURE(AccDeviceTypeExprList)
  READ_FEATURE(AccTileExpr)
  READ_FEATURE(AccTileExprList)
  READ_FEATURE(AccLoopDirective)
  READ_FEATURE(AccWaitArgument)
  READ_FEATURE(AcImpliedDo)
  READ_FEATURE(AcImpliedDoControl)
  READ_FEATURE(AcValue)
  READ_FEATURE(AccessStmt)
  READ_FEATURE(AccessId)
  READ_FEATURE(AccessSpec)
  READ_FEATURE(AccessSpec::Kind)
  READ_FEATURE(AcSpec)
  READ_FEATURE(ActionStmt)
  READ_FEATURE(ActualArg)
  READ_FEATURE(ActualArg::PercentRef)
  READ_FEATURE(ActualArg::PercentVal)
  READ_FEATURE(ActualArgSpec)
  READ_FEATURE(AcValue::Triplet)
  READ_FEATURE(AllocOpt)
  READ_FEATURE(AllocOpt::Mold)
  READ_FEATURE(AllocOpt::Source)
  READ_FEATURE(Allocatable)
  READ_FEATURE(AllocatableStmt)
  READ_FEATURE(AllocateCoarraySpec)
  READ_FEATURE(AllocateObject)
  READ_FEATURE(AllocateShapeSpec)
  READ_FEATURE(AllocateStmt)
  READ_FEATURE(Allocation)
  READ_FEATURE(AltReturnSpec)
  READ_FEATURE(ArithmeticIfStmt)
  READ_FEATURE(ArrayConstructor)
  READ_FEATURE(ArrayElement)
  READ_FEATURE(ArraySpec)
  READ_FEATURE(AssignStmt)
  READ_FEATURE(AssignedGotoStmt)
  READ_FEATURE(AssignmentStmt)
  READ_FEATURE(AssociateConstruct)
  READ_FEATURE(AssociateStmt)
  READ_FEATURE(Association)
  READ_FEATURE(AssumedImpliedSpec)
  READ_FEATURE(AssumedRankSpec)
  READ_FEATURE(AssumedShapeSpec)
  READ_FEATURE(AssumedSizeSpec)
  READ_FEATURE(Asynchronous)
  READ_FEATURE(AsynchronousStmt)
  READ_FEATURE(AttrSpec)
  READ_FEATURE(BOZLiteralConstant)
  READ_FEATURE(BackspaceStmt)
  READ_FEATURE(BasedPointer)
  READ_FEATURE(BasedPointerStmt)
  READ_FEATURE(BindAttr)
  READ_FEATURE(BindAttr::Deferred)
  READ_FEATURE(BindAttr::Non_Overridable)
  READ_FEATURE(BindEntity)
  READ_FEATURE(BindEntity::Kind)
  READ_FEATURE(BindStmt)
  READ_FEATURE(Block)
  READ_FEATURE(BlockConstruct)
  READ_FEATURE(BlockData)
  READ_FEATURE(BlockDataStmt)
  READ_FEATURE(BlockSpecificationPart)
  READ_FEATURE(BlockStmt)
  READ_FEATURE(BoundsRemapping)
  READ_FEATURE(BoundsSpec)
  READ_FEATURE(Call)
  READ_FEATURE(CallStmt)
  READ_FEATURE(CaseConstruct)
  READ_FEATURE(CaseConstruct::Case)
  READ_FEATURE(CaseSelector)
  READ_FEATURE(CaseStmt)
  READ_FEATURE(CaseValueRange)
  READ_FEATURE(CaseValueRange::Range)
  READ_FEATURE(ChangeTeamConstruct)
  READ_FEATURE(ChangeTeamStmt)
  READ_FEATURE(CharLength)
  READ_FEATURE(CharLiteralConstant)
  READ_FEATURE(CharLiteralConstantSubstring)
  READ_FEATURE(CharSelector)
  READ_FEATURE(CharSelector::LengthAndKind)
  READ_FEATURE(CloseStmt)
  READ_FEATURE(CloseStmt::CloseSpec)
  READ_FEATURE(CoarrayAssociation)
  READ_FEATURE(CoarraySpec)
  READ_FEATURE(CodimensionDecl)
  READ_FEATURE(CodimensionStmt)
  READ_FEATURE(CoindexedNamedObject)
  READ_FEATURE(CommonBlockObject)
  READ_FEATURE(CommonStmt)
  READ_FEATURE(CommonStmt::Block)
  READ_FEATURE(CompilerDirective)
  READ_FEATURE(CompilerDirective::IgnoreTKR)
  READ_FEATURE(CompilerDirective::LoopCount)
  READ_FEATURE(CompilerDirective::NameValue)
  READ_FEATURE(ComplexLiteralConstant)
  READ_FEATURE(ComplexPart)
  READ_FEATURE(ComponentArraySpec)
  READ_FEATURE(ComponentAttrSpec)
  READ_FEATURE(ComponentDataSource)
  READ_FEATURE(ComponentDecl)
  READ_FEATURE(FillDecl)
  READ_FEATURE(ComponentOrFill)
  READ_FEATURE(ComponentDefStmt)
  READ_FEATURE(ComponentSpec)
  READ_FEATURE(ComputedGotoStmt)
  READ_FEATURE(ConcurrentControl)
  READ_FEATURE(ConcurrentHeader)
  READ_FEATURE(ConnectSpec)
  READ_FEATURE(ConnectSpec::CharExpr)
  READ_FEATURE(ConnectSpec::CharExpr::Kind)
  READ_FEATURE(ConnectSpec::Newunit)
  READ_FEATURE(ConnectSpec::Recl)
  READ_FEATURE(ContainsStmt)
  READ_FEATURE(Contiguous)
  READ_FEATURE(ContiguousStmt)
  READ_FEATURE(ContinueStmt)
  READ_FEATURE(CriticalConstruct)
  READ_FEATURE(CriticalStmt)
  READ_FEATURE(CycleStmt)
  READ_FEATURE(DataComponentDefStmt)
  READ_FEATURE(DataIDoObject)
  READ_FEATURE(DataImpliedDo)
  READ_FEATURE(DataRef)
  READ_FEATURE(DataStmt)
  READ_FEATURE(DataStmtConstant)
  READ_FEATURE(DataStmtObject)
  READ_FEATURE(DataStmtRepeat)
  READ_FEATURE(DataStmtSet)
  READ_FEATURE(DataStmtValue)
  READ_FEATURE(DeallocateStmt)
  READ_FEATURE(DeclarationConstruct)
  READ_FEATURE(DeclarationTypeSpec)
  READ_FEATURE(DeclarationTypeSpec::Class)
  READ_FEATURE(DeclarationTypeSpec::ClassStar)
  READ_FEATURE(DeclarationTypeSpec::Record)
  READ_FEATURE(DeclarationTypeSpec::Type)
  READ_FEATURE(DeclarationTypeSpec::TypeStar)
  READ_FEATURE(Default)
  READ_FEATURE(DeferredCoshapeSpecList)
  READ_FEATURE(DeferredShapeSpecList)
  READ_FEATURE(DefinedOpName)
  READ_FEATURE(DefinedOperator)
  READ_FEATURE(DefinedOperator::IntrinsicOperator)
  READ_FEATURE(DerivedTypeDef)
  READ_FEATURE(DerivedTypeSpec)
  READ_FEATURE(DerivedTypeStmt)
  READ_FEATURE(Designator)
  READ_FEATURE(DimensionStmt)
  READ_FEATURE(DimensionStmt::Declaration)
  READ_FEATURE(DoConstruct)
  READ_FEATURE(DummyArg)
  READ_FEATURE(ElseIfStmt)
  READ_FEATURE(ElseStmt)
  READ_FEATURE(ElsewhereStmt)
  READ_FEATURE(EndAssociateStmt)
  READ_FEATURE(EndBlockDataStmt)
  READ_FEATURE(EndBlockStmt)
  READ_FEATURE(EndChangeTeamStmt)
  READ_FEATURE(EndCriticalStmt)
  READ_FEATURE(EndDoStmt)
  READ_FEATURE(EndEnumStmt)
  READ_FEATURE(EndForallStmt)
  READ_FEATURE(EndFunctionStmt)
  READ_FEATURE(EndIfStmt)
  READ_FEATURE(EndInterfaceStmt)
  READ_FEATURE(EndLabel)
  READ_FEATURE(EndModuleStmt)
  READ_FEATURE(EndMpSubprogramStmt)
  READ_FEATURE(EndProgramStmt)
  READ_FEATURE(EndSelectStmt)
  READ_FEATURE(EndSubmoduleStmt)
  READ_FEATURE(EndSubroutineStmt)
  READ_FEATURE(EndTypeStmt)
  READ_FEATURE(EndWhereStmt)
  READ_FEATURE(EndfileStmt)
  READ_FEATURE(EntityDecl)
  READ_FEATURE(EntryStmt)
  READ_FEATURE(EnumDef)
  READ_FEATURE(EnumDefStmt)
  READ_FEATURE(Enumerator)
  READ_FEATURE(EnumeratorDefStmt)
  READ_FEATURE(EorLabel)
  READ_FEATURE(EquivalenceObject)
  READ_FEATURE(EquivalenceStmt)
  READ_FEATURE(ErrLabel)
  READ_FEATURE(ErrorRecovery)
  READ_FEATURE(EventPostStmt)
  READ_FEATURE(EventWaitStmt)
  READ_FEATURE(EventWaitStmt::EventWaitSpec)
  READ_FEATURE(ExecutableConstruct)
  READ_FEATURE(ExecutionPart)
  READ_FEATURE(ExecutionPartConstruct)
  READ_FEATURE(ExitStmt)
  READ_FEATURE(ExplicitCoshapeSpec)
  READ_FEATURE(ExplicitShapeSpec)
  READ_FEATURE(Expr)
  READ_FEATURE(Expr::Parentheses)
  READ_FEATURE(Expr::UnaryPlus)
  READ_FEATURE(Expr::Negate)
  READ_FEATURE(Expr::NOT)
  READ_FEATURE(Expr::PercentLoc)
  READ_FEATURE(Expr::DefinedUnary)
  READ_FEATURE(Expr::Power)
  READ_FEATURE(Expr::Multiply)
  READ_FEATURE(Expr::Divide)
  READ_FEATURE(Expr::Add)
  READ_FEATURE(Expr::Subtract)
  READ_FEATURE(Expr::Concat)
  READ_FEATURE(Expr::LT)
  READ_FEATURE(Expr::LE)
  READ_FEATURE(Expr::EQ)
  READ_FEATURE(Expr::NE)
  READ_FEATURE(Expr::GE)
  READ_FEATURE(Expr::GT)
  READ_FEATURE(Expr::AND)
  READ_FEATURE(Expr::OR)
  READ_FEATURE(Expr::EQV)
  READ_FEATURE(Expr::NEQV)
  READ_FEATURE(Expr::DefinedBinary)
  READ_FEATURE(Expr::ComplexConstructor)
  READ_FEATURE(External)
  READ_FEATURE(ExternalStmt)
  READ_FEATURE(FailImageStmt)
  READ_FEATURE(FileUnitNumber)
  READ_FEATURE(FinalProcedureStmt)
  READ_FEATURE(FlushStmt)
  READ_FEATURE(ForallAssignmentStmt)
  READ_FEATURE(ForallBodyConstruct)
  READ_FEATURE(ForallConstruct)
  READ_FEATURE(ForallConstructStmt)
  READ_FEATURE(ForallStmt)
  READ_FEATURE(FormTeamStmt)
  READ_FEATURE(FormTeamStmt::FormTeamSpec)
  READ_FEATURE(Format)
  READ_FEATURE(FormatStmt)
  READ_FEATURE(FunctionReference)
  READ_FEATURE(FunctionStmt)
  READ_FEATURE(FunctionSubprogram)
  READ_FEATURE(GenericSpec)
  READ_FEATURE(GenericSpec::Assignment)
  READ_FEATURE(GenericSpec::ReadFormatted)
  READ_FEATURE(GenericSpec::ReadUnformatted)
  READ_FEATURE(GenericSpec::WriteFormatted)
  READ_FEATURE(GenericSpec::WriteUnformatted)
  READ_FEATURE(GenericStmt)
  READ_FEATURE(GotoStmt)
  READ_FEATURE(HollerithLiteralConstant)
  READ_FEATURE(IdExpr)
  READ_FEATURE(IdVariable)
  READ_FEATURE(IfConstruct)
  READ_FEATURE(IfConstruct::ElseBlock)
  READ_FEATURE(IfConstruct::ElseIfBlock)
  READ_FEATURE(IfStmt)
  READ_FEATURE(IfThenStmt)
  READ_FEATURE(TeamValue)
  READ_FEATURE(ImageSelector)
  READ_FEATURE(ImageSelectorSpec)
  READ_FEATURE(ImageSelectorSpec::Stat)
  READ_FEATURE(ImageSelectorSpec::Team_Number)
  READ_FEATURE(ImplicitPart)
  READ_FEATURE(ImplicitPartStmt)
  READ_FEATURE(ImplicitSpec)
  READ_FEATURE(ImplicitStmt)
  READ_FEATURE(ImplicitStmt::ImplicitNoneNameSpec)
  READ_FEATURE(ImpliedShapeSpec)
  READ_FEATURE(ImportStmt)
  READ_FEATURE(Initialization)
  READ_FEATURE(InputImpliedDo)
  READ_FEATURE(InputItem)
  READ_FEATURE(InquireSpec)
  READ_FEATURE(InquireSpec::CharVar)
  READ_FEATURE(InquireSpec::CharVar::Kind)
  READ_FEATURE(InquireSpec::IntVar)
  READ_FEATURE(InquireSpec::IntVar::Kind)
  READ_FEATURE(InquireSpec::LogVar)
  READ_FEATURE(InquireSpec::LogVar::Kind)
  READ_FEATURE(InquireStmt)
  READ_FEATURE(InquireStmt::Iolength)
  READ_FEATURE(IntegerTypeSpec)
  READ_FEATURE(IntentSpec)
  READ_FEATURE(IntentSpec::Intent)
  READ_FEATURE(IntentStmt)
  READ_FEATURE(InterfaceBlock)
  READ_FEATURE(InterfaceBody)
  READ_FEATURE(InterfaceBody::Function)
  READ_FEATURE(InterfaceBody::Subroutine)
  READ_FEATURE(InterfaceSpecification)
  READ_FEATURE(InterfaceStmt)
  READ_FEATURE(InternalSubprogram)
  READ_FEATURE(InternalSubprogramPart)
  READ_FEATURE(Intrinsic)
  READ_FEATURE(IntrinsicStmt)
  READ_FEATURE(IntrinsicTypeSpec)
  READ_FEATURE(IntrinsicTypeSpec::Character)
  READ_FEATURE(IntrinsicTypeSpec::Complex)
  READ_FEATURE(IntrinsicTypeSpec::DoubleComplex)
  READ_FEATURE(IntrinsicTypeSpec::DoublePrecision)
  READ_FEATURE(IntrinsicTypeSpec::Logical)
  READ_FEATURE(IntrinsicTypeSpec::Real)
  READ_FEATURE(IoControlSpec)
  READ_FEATURE(IoControlSpec::Asynchronous)
  READ_FEATURE(IoControlSpec::CharExpr)
  READ_FEATURE(IoControlSpec::CharExpr::Kind)
  READ_FEATURE(IoControlSpec::Pos)
  READ_FEATURE(IoControlSpec::Rec)
  READ_FEATURE(IoControlSpec::Size)
  READ_FEATURE(IoUnit)
  READ_FEATURE(Keyword)
  READ_FEATURE(KindParam)
  READ_FEATURE(KindSelector)
  READ_FEATURE(KindSelector::StarSize)
  READ_FEATURE(LabelDoStmt)
  READ_FEATURE(LanguageBindingSpec)
  READ_FEATURE(LengthSelector)
  READ_FEATURE(LetterSpec)
  READ_FEATURE(LiteralConstant)
  READ_FEATURE(IntLiteralConstant)
  READ_FEATURE(LocalitySpec)
  READ_FEATURE(LocalitySpec::DefaultNone)
  READ_FEATURE(LocalitySpec::Local)
  READ_FEATURE(LocalitySpec::LocalInit)
  READ_FEATURE(LocalitySpec::Shared)
  READ_FEATURE(LockStmt)
  READ_FEATURE(LockStmt::LockStat)
  READ_FEATURE(LogicalLiteralConstant)
  READ_FEATURE(LoopControl)
  READ_FEATURE(LoopControl::Concurrent)
  READ_FEATURE(MainProgram)
  READ_FEATURE(Map)
  READ_FEATURE(Map::EndMapStmt)
  READ_FEATURE(Map::MapStmt)
  READ_FEATURE(MaskedElsewhereStmt)
  READ_FEATURE(Module)
  READ_FEATURE(ModuleStmt)
  READ_FEATURE(ModuleSubprogram)
  READ_FEATURE(ModuleSubprogramPart)
  READ_FEATURE(MpSubprogramStmt)
  READ_FEATURE(MsgVariable)
  READ_FEATURE(Name)
  READ_FEATURE(NamedConstant)
  READ_FEATURE(NamedConstantDef)
  READ_FEATURE(NamelistStmt)
  READ_FEATURE(NamelistStmt::Group)
  READ_FEATURE(NonLabelDoStmt)
  READ_FEATURE(NoPass)
  READ_FEATURE(NullifyStmt)
  READ_FEATURE(NullInit)
  READ_FEATURE(ObjectDecl)
  READ_FEATURE(OldParameterStmt)
  READ_FEATURE(OmpAlignedClause)
  READ_FEATURE(OmpAtomic)
  READ_FEATURE(OmpAtomicCapture)
  READ_FEATURE(OmpAtomicCapture::Stmt1)
  READ_FEATURE(OmpAtomicCapture::Stmt2)
  READ_FEATURE(OmpAtomicRead)
  READ_FEATURE(OmpAtomicUpdate)
  READ_FEATURE(OmpAtomicWrite)
  READ_FEATURE(OmpBeginBlockDirective)
  READ_FEATURE(OmpBeginLoopDirective)
  READ_FEATURE(OmpBeginSectionsDirective)
  READ_FEATURE(OmpBlockDirective)
  READ_FEATURE(OmpCancelType)
  READ_FEATURE(OmpCancelType::Type)
  READ_FEATURE(OmpClause)
  READ_FEATURE(OmpClauseList)
  READ_FEATURE(OmpCriticalDirective)
  READ_FEATURE(OmpDeclareTargetSpecifier)
  READ_FEATURE(OmpDeclareTargetWithClause)
  READ_FEATURE(OmpDeclareTargetWithList)
  READ_FEATURE(OmpDefaultClause)
  READ_FEATURE(OmpDefaultClause::Type)
  READ_FEATURE(OmpDefaultmapClause)
  READ_FEATURE(OmpDefaultmapClause::ImplicitBehavior)
  READ_FEATURE(OmpDefaultmapClause::VariableCategory)
  READ_FEATURE(OmpDependClause)
  READ_FEATURE(OmpDependClause::InOut)
  READ_FEATURE(OmpDependClause::Sink)
  READ_FEATURE(OmpDependClause::Source)
  READ_FEATURE(OmpDependenceType)
  READ_FEATURE(OmpDependenceType::Type)
  READ_FEATURE(OmpDependSinkVec)
  READ_FEATURE(OmpDependSinkVecLength)
  READ_FEATURE(OmpEndAllocators)
  READ_FEATURE(OmpEndAtomic)
  READ_FEATURE(OmpEndBlockDirective)
  READ_FEATURE(OmpEndCriticalDirective)
  READ_FEATURE(OmpEndLoopDirective)
  READ_FEATURE(OmpEndSectionsDirective)
  READ_FEATURE(OmpIfClause)
  READ_FEATURE(OmpIfClause::DirectiveNameModifier)
  READ_FEATURE(OmpLinearClause)
  READ_FEATURE(OmpLinearClause::WithModifier)
  READ_FEATURE(OmpLinearClause::WithoutModifier)
  READ_FEATURE(OmpLinearModifier)
  READ_FEATURE(OmpLinearModifier::Type)
  READ_FEATURE(OmpLoopDirective)
  READ_FEATURE(OmpMapClause)
  READ_FEATURE(OmpMapType)
  READ_FEATURE(OmpMapType::Always)
  READ_FEATURE(OmpMapType::Type)
  READ_FEATURE(OmpObject)
  READ_FEATURE(OmpObjectList)
  READ_FEATURE(OmpOrderClause)
  READ_FEATURE(OmpOrderClause::Type)
  READ_FEATURE(OmpOrderModifier)
  READ_FEATURE(OmpOrderModifier::Kind)
  READ_FEATURE(OmpProcBindClause)
  READ_FEATURE(OmpProcBindClause::Type)
  READ_FEATURE(OmpReductionClause)
  READ_FEATURE(OmpInReductionClause)
  READ_FEATURE(OmpReductionCombiner)
  READ_FEATURE(OmpReductionCombiner::FunctionCombiner)
  READ_FEATURE(OmpReductionInitializerClause)
  READ_FEATURE(OmpReductionOperator)
  READ_FEATURE(OmpAllocateClause)
  READ_FEATURE(OmpAllocateClause::AllocateModifier)
  READ_FEATURE(OmpAllocateClause::AllocateModifier::Allocator)
  READ_FEATURE(OmpAllocateClause::AllocateModifier::ComplexModifier)
  READ_FEATURE(OmpAllocateClause::AllocateModifier::Align)
  READ_FEATURE(OmpScheduleClause)
  READ_FEATURE(OmpScheduleClause::ScheduleType)
  READ_FEATURE(OmpDeviceClause)
  READ_FEATURE(OmpDeviceClause::DeviceModifier)
  READ_FEATURE(OmpDeviceTypeClause)
  READ_FEATURE(OmpDeviceTypeClause::Type)
  READ_FEATURE(OmpScheduleModifier)
  READ_FEATURE(OmpScheduleModifier::Modifier1)
  READ_FEATURE(OmpScheduleModifier::Modifier2)
  READ_FEATURE(OmpScheduleModifierType)
  READ_FEATURE(OmpScheduleModifierType::ModType)
  READ_FEATURE(OmpSectionBlocks)
  READ_FEATURE(OmpSectionsDirective)
  READ_FEATURE(OmpSimpleStandaloneDirective)
  READ_FEATURE(Only)
  READ_FEATURE(OpenACCAtomicConstruct)
  READ_FEATURE(OpenACCBlockConstruct)
  READ_FEATURE(OpenACCCacheConstruct)
  READ_FEATURE(OpenACCCombinedConstruct)
  READ_FEATURE(OpenACCConstruct)
  READ_FEATURE(OpenACCDeclarativeConstruct)
  READ_FEATURE(OpenACCLoopConstruct)
  READ_FEATURE(OpenACCRoutineConstruct)
  READ_FEATURE(OpenACCStandaloneDeclarativeConstruct)
  READ_FEATURE(OpenACCStandaloneConstruct)
  READ_FEATURE(OpenACCWaitConstruct)
  READ_FEATURE(OpenMPAtomicConstruct)
  READ_FEATURE(OpenMPBlockConstruct)
  READ_FEATURE(OpenMPCancelConstruct)
  READ_FEATURE(OpenMPCancelConstruct::If)
  READ_FEATURE(OpenMPCancellationPointConstruct)
  READ_FEATURE(OpenMPConstruct)
  READ_FEATURE(OpenMPCriticalConstruct)
  READ_FEATURE(OpenMPDeclarativeAllocate)
  READ_FEATURE(OpenMPDeclarativeConstruct)
  READ_FEATURE(OpenMPDeclareReductionConstruct)
  READ_FEATURE(OpenMPDeclareSimdConstruct)
  READ_FEATURE(OpenMPDeclareTargetConstruct)
  READ_FEATURE(OmpMemoryOrderClause)
  READ_FEATURE(OmpAtomicClause)
  READ_FEATURE(OmpAtomicClauseList)
  READ_FEATURE(OmpAtomicDefaultMemOrderClause)
  READ_FEATURE(OmpAtomicDefaultMemOrderClause::Type)
  READ_FEATURE(OpenMPFlushConstruct)
  READ_FEATURE(OpenMPLoopConstruct)
  READ_FEATURE(OpenMPExecutableAllocate)
  READ_FEATURE(OpenMPAllocatorsConstruct)
  READ_FEATURE(OpenMPRequiresConstruct)
  READ_FEATURE(OpenMPSimpleStandaloneConstruct)
  READ_FEATURE(OpenMPStandaloneConstruct)
  READ_FEATURE(OpenMPSectionConstruct)
  READ_FEATURE(OpenMPSectionsConstruct)
  READ_FEATURE(OpenMPThreadprivate)
  READ_FEATURE(OpenStmt)
  READ_FEATURE(Optional)
  READ_FEATURE(OptionalStmt)
  READ_FEATURE(OtherSpecificationStmt)
  READ_FEATURE(OutputImpliedDo)
  READ_FEATURE(OutputItem)
  READ_FEATURE(Parameter)
  READ_FEATURE(ParameterStmt)
  READ_FEATURE(ParentIdentifier)
  READ_FEATURE(Pass)
  READ_FEATURE(PauseStmt)
  READ_FEATURE(Pointer)
  READ_FEATURE(PointerAssignmentStmt)
  READ_FEATURE(PointerAssignmentStmt::Bounds)
  READ_FEATURE(PointerDecl)
  READ_FEATURE(PointerObject)
  READ_FEATURE(PointerStmt)
  READ_FEATURE(PositionOrFlushSpec)
  READ_FEATURE(PrefixSpec)
  READ_FEATURE(PrefixSpec::Elemental)
  READ_FEATURE(PrefixSpec::Impure)
  READ_FEATURE(PrefixSpec::Module)
  READ_FEATURE(PrefixSpec::Non_Recursive)
  READ_FEATURE(PrefixSpec::Pure)
  READ_FEATURE(PrefixSpec::Recursive)
  READ_FEATURE(PrintStmt)
  READ_FEATURE(PrivateStmt)
  READ_FEATURE(PrivateOrSequence)
  READ_FEATURE(ProcAttrSpec)
  READ_FEATURE(ProcComponentAttrSpec)
  READ_FEATURE(ProcComponentDefStmt)
  READ_FEATURE(ProcComponentRef)
  READ_FEATURE(ProcDecl)
  READ_FEATURE(ProcInterface)
  READ_FEATURE(ProcPointerInit)
  READ_FEATURE(ProcedureDeclarationStmt)
  READ_FEATURE(ProcedureDesignator)
  READ_FEATURE(ProcedureStmt)
  READ_FEATURE(ProcedureStmt::Kind)
  READ_FEATURE(Program)
  READ_FEATURE(ProgramStmt)
  READ_FEATURE(ProgramUnit)
  READ_FEATURE(Protected)
  READ_FEATURE(ProtectedStmt)
  READ_FEATURE(ReadStmt)
  READ_FEATURE(RealLiteralConstant)
  READ_FEATURE(RealLiteralConstant::Real)
  READ_FEATURE(Rename)
  READ_FEATURE(Rename::Names)
  READ_FEATURE(Rename::Operators)
  READ_FEATURE(ReturnStmt)
  READ_FEATURE(RewindStmt)
  READ_FEATURE(Save)
  READ_FEATURE(SaveStmt)
  READ_FEATURE(SavedEntity)
  READ_FEATURE(SavedEntity::Kind)
  READ_FEATURE(SectionSubscript)
  READ_FEATURE(SelectCaseStmt)
  READ_FEATURE(SelectRankCaseStmt)
  READ_FEATURE(SelectRankCaseStmt::Rank)
  READ_FEATURE(SelectRankConstruct)
  READ_FEATURE(SelectRankConstruct::RankCase)
  READ_FEATURE(SelectRankStmt)
  READ_FEATURE(SelectTypeConstruct)
  READ_FEATURE(SelectTypeConstruct::TypeCase)
  READ_FEATURE(SelectTypeStmt)
  READ_FEATURE(Selector)
  READ_FEATURE(SeparateModuleSubprogram)
  READ_FEATURE(SequenceStmt)
  READ_FEATURE(Sign)
  READ_FEATURE(SignedComplexLiteralConstant)
  READ_FEATURE(SignedIntLiteralConstant)
  READ_FEATURE(SignedRealLiteralConstant)
  READ_FEATURE(SpecificationConstruct)
  READ_FEATURE(SpecificationExpr)
  READ_FEATURE(SpecificationPart)
  READ_FEATURE(Star)
  READ_FEATURE(StatOrErrmsg)
  READ_FEATURE(StatVariable)
  READ_FEATURE(StatusExpr)
  READ_FEATURE(StmtFunctionStmt)
  READ_FEATURE(StopCode)
  READ_FEATURE(StopStmt)
  READ_FEATURE(StopStmt::Kind)
  READ_FEATURE(StructureComponent)
  READ_FEATURE(StructureConstructor)
  READ_FEATURE(StructureDef)
  READ_FEATURE(StructureDef::EndStructureStmt)
  READ_FEATURE(StructureField)
  READ_FEATURE(StructureStmt)
  READ_FEATURE(Submodule)
  READ_FEATURE(SubmoduleStmt)
  READ_FEATURE(SubroutineStmt)
  READ_FEATURE(SubroutineSubprogram)
  READ_FEATURE(SubscriptTriplet)
  READ_FEATURE(Substring)
  READ_FEATURE(SubstringInquiry)
  READ_FEATURE(SubstringRange)
  READ_FEATURE(Suffix)
  READ_FEATURE(SyncAllStmt)
  READ_FEATURE(SyncImagesStmt)
  READ_FEATURE(SyncImagesStmt::ImageSet)
  READ_FEATURE(SyncMemoryStmt)
  READ_FEATURE(SyncTeamStmt)
  READ_FEATURE(Target)
  READ_FEATURE(TargetStmt)
  READ_FEATURE(TypeAttrSpec)
  READ_FEATURE(TypeAttrSpec::BindC)
  READ_FEATURE(TypeAttrSpec::Extends)
  READ_FEATURE(TypeBoundGenericStmt)
  READ_FEATURE(TypeBoundProcBinding)
  READ_FEATURE(TypeBoundProcDecl)
  READ_FEATURE(TypeBoundProcedurePart)
  READ_FEATURE(TypeBoundProcedureStmt)
  READ_FEATURE(TypeBoundProcedureStmt::WithInterface)
  READ_FEATURE(TypeBoundProcedureStmt::WithoutInterface)
  READ_FEATURE(TypeDeclarationStmt)
  READ_FEATURE(TypeGuardStmt)
  READ_FEATURE(TypeGuardStmt::Guard)
  READ_FEATURE(TypeParamDecl)
  READ_FEATURE(TypeParamDefStmt)
  READ_FEATURE(common::TypeParamAttr)
  READ_FEATURE(TypeParamSpec)
  READ_FEATURE(TypeParamValue)
  READ_FEATURE(TypeParamValue::Deferred)
  READ_FEATURE(TypeSpec)
  READ_FEATURE(Union)
  READ_FEATURE(Union::EndUnionStmt)
  READ_FEATURE(Union::UnionStmt)
  READ_FEATURE(UnlockStmt)
  READ_FEATURE(UseStmt)
  READ_FEATURE(UseStmt::ModuleNature)
  READ_FEATURE(Value)
  READ_FEATURE(ValueStmt)
  READ_FEATURE(Variable)
  READ_FEATURE(Verbatim)
  READ_FEATURE(Volatile)
  READ_FEATURE(VolatileStmt)
  READ_FEATURE(WaitSpec)
  READ_FEATURE(WaitStmt)
  READ_FEATURE(WhereBodyConstruct)
  READ_FEATURE(WhereConstruct)
  READ_FEATURE(WhereConstruct::Elsewhere)
  READ_FEATURE(WhereConstruct::MaskedElsewhere)
  READ_FEATURE(WhereConstructStmt)
  READ_FEATURE(WhereStmt)
  READ_FEATURE(WriteStmt)

  READ_FEATURE(llvm::omp::Directive)
  READ_FEATURE(llvm::omp::Clause)
  READ_FEATURE(llvm::acc::Directive)
  READ_FEATURE(llvm::acc::DefaultValue)

  template <typename A> bool Pre(const A &) { return true; }
  template <typename A> void Post(const A &) {}

  template <typename T> bool Pre(const Statement<T> &) { return true; }
  template <typename T> void Post(const Statement<T> &) {}

  template <typename T> bool Pre(const UnlabeledStatement<T> &) { return true; }
  template <typename T> void Post(const UnlabeledStatement<T> &) {}

  template <typename T> bool Pre(const common::Indirection<T> &) {
    return true;
  }
  template <typename T> void Post(const common::Indirection<T> &) {}

  template <typename A> bool Pre(const Scalar<A> &) { return true; }
  template <typename A> void Post(const Scalar<A> &) {}

  template <typename A> bool Pre(const Constant<A> &) { return true; }
  template <typename A> void Post(const Constant<A> &) {}

  template <typename A> bool Pre(const Integer<A> &) { return true; }
  template <typename A> void Post(const Integer<A> &) {}

  template <typename A> bool Pre(const Logical<A> &) { return true; }
  template <typename A> void Post(const Logical<A> &) {}

  template <typename A> bool Pre(const DefaultChar<A> &) { return true; }
  template <typename A> void Post(const DefaultChar<A> &) {}

  template <typename... A> bool Pre(const std::tuple<A...> &) { return true; }
  template <typename... A> void Post(const std::tuple<A...> &) {}

  template <typename... A> bool Pre(const std::variant<A...> &) { return true; }
  template <typename... A> void Post(const std::variant<A...> &) {}
};

bool sortNodes(std::pair<const char *, int> a, std::pair<const char *, int> b) {
  return (a.second == b.second) ? (std::strcmp(a.first, b.first) < 0)
                                : a.second > b.second;
}

class FeatureListAction : public PluginParseTreeAction {
  void executeAction() override {
    NodeVisitor visitor;
    Fortran::parser::Walk(getParsing().parseTree(), visitor);

    const auto &frequencyMap = visitor.getFrequencies();
    std::vector<std::pair<const char *, int>> frequencies(
        frequencyMap.begin(), frequencyMap.end());

    std::sort(frequencies.begin(), frequencies.end(), sortNodes);
    for (auto const &[feature, frequency] : frequencies) {
      llvm::outs() << feature << ": " << frequency << "\n";
    }
  }

  bool beginSourceFileAction() override { return runPrescan() && runParse(); }
};

static FrontendPluginRegistry::Add<FeatureListAction> X(
    "feature-list", "List program features");