// Generated by gencpp from file turtlebot3_example/Turtlebot3Feedback.msg
// DO NOT EDIT!


#ifndef TURTLEBOT3_EXAMPLE_MESSAGE_TURTLEBOT3FEEDBACK_H
#define TURTLEBOT3_EXAMPLE_MESSAGE_TURTLEBOT3FEEDBACK_H


#include <string>
#include <vector>
#include <map>

#include <ros/types.h>
#include <ros/serialization.h>
#include <ros/builtin_message_traits.h>
#include <ros/message_operations.h>


namespace turtlebot3_example
{
template <class ContainerAllocator>
struct Turtlebot3Feedback_
{
  typedef Turtlebot3Feedback_<ContainerAllocator> Type;

  Turtlebot3Feedback_()
    : state()  {
    }
  Turtlebot3Feedback_(const ContainerAllocator& _alloc)
    : state(_alloc)  {
  (void)_alloc;
    }



   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _state_type;
  _state_type state;





  typedef boost::shared_ptr< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> const> ConstPtr;

}; // struct Turtlebot3Feedback_

typedef ::turtlebot3_example::Turtlebot3Feedback_<std::allocator<void> > Turtlebot3Feedback;

typedef boost::shared_ptr< ::turtlebot3_example::Turtlebot3Feedback > Turtlebot3FeedbackPtr;
typedef boost::shared_ptr< ::turtlebot3_example::Turtlebot3Feedback const> Turtlebot3FeedbackConstPtr;

// constants requiring out of line definition



template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> & v)
{
ros::message_operations::Printer< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >::stream(s, "", v);
return s;
}

} // namespace turtlebot3_example

namespace ros
{
namespace message_traits
{



// BOOLTRAITS {'IsFixedSize': False, 'IsMessage': True, 'HasHeader': False}
// {'turtlebot3_example': ['/home/basti/git_repository/projektarbeit/catkin_ws/devel/share/turtlebot3_example/msg'], 'actionlib_msgs': ['/opt/ros/kinetic/share/actionlib_msgs/cmake/../msg'], 'std_msgs': ['/opt/ros/kinetic/share/std_msgs/cmake/../msg'], 'geometry_msgs': ['/opt/ros/kinetic/share/geometry_msgs/cmake/../msg']}

// !!!!!!!!!!! ['__class__', '__delattr__', '__dict__', '__doc__', '__eq__', '__format__', '__getattribute__', '__hash__', '__init__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_parsed_fields', 'constants', 'fields', 'full_name', 'has_header', 'header_present', 'names', 'package', 'parsed_fields', 'short_name', 'text', 'types']




template <class ContainerAllocator>
struct IsFixedSize< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct IsFixedSize< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> const>
  : FalseType
  { };

template <class ContainerAllocator>
struct IsMessage< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct HasHeader< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct HasHeader< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> const>
  : FalseType
  { };


template<class ContainerAllocator>
struct MD5Sum< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
{
  static const char* value()
  {
    return "af6d3a99f0fbeb66d3248fa4b3e675fb";
  }

  static const char* value(const ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator>&) { return value(); }
  static const uint64_t static_value1 = 0xaf6d3a99f0fbeb66ULL;
  static const uint64_t static_value2 = 0xd3248fa4b3e675fbULL;
};

template<class ContainerAllocator>
struct DataType< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
{
  static const char* value()
  {
    return "turtlebot3_example/Turtlebot3Feedback";
  }

  static const char* value(const ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator>&) { return value(); }
};

template<class ContainerAllocator>
struct Definition< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
{
  static const char* value()
  {
    return "# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======\n\
# Define a feedback message\n\
string state\n\
\n\
";
  }

  static const char* value(const ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator>&) { return value(); }
};

} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

  template<class ContainerAllocator> struct Serializer< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
  {
    template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
    {
      stream.next(m.state);
    }

    ROS_DECLARE_ALLINONE_SERIALIZER
  }; // struct Turtlebot3Feedback_

} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const ::turtlebot3_example::Turtlebot3Feedback_<ContainerAllocator>& v)
  {
    s << indent << "state: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.state);
  }
};

} // namespace message_operations
} // namespace ros

#endif // TURTLEBOT3_EXAMPLE_MESSAGE_TURTLEBOT3FEEDBACK_H
