// Generated by gencpp from file turtlebot3_msgs/VersionInfo.msg
// DO NOT EDIT!


#ifndef TURTLEBOT3_MSGS_MESSAGE_VERSIONINFO_H
#define TURTLEBOT3_MSGS_MESSAGE_VERSIONINFO_H


#include <string>
#include <vector>
#include <map>

#include <ros/types.h>
#include <ros/serialization.h>
#include <ros/builtin_message_traits.h>
#include <ros/message_operations.h>


namespace turtlebot3_msgs
{
template <class ContainerAllocator>
struct VersionInfo_
{
  typedef VersionInfo_<ContainerAllocator> Type;

  VersionInfo_()
    : hardware()
    , firmware()
    , software()  {
    }
  VersionInfo_(const ContainerAllocator& _alloc)
    : hardware(_alloc)
    , firmware(_alloc)
    , software(_alloc)  {
  (void)_alloc;
    }



   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _hardware_type;
  _hardware_type hardware;

   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _firmware_type;
  _firmware_type firmware;

   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _software_type;
  _software_type software;





  typedef boost::shared_ptr< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> const> ConstPtr;

}; // struct VersionInfo_

typedef ::turtlebot3_msgs::VersionInfo_<std::allocator<void> > VersionInfo;

typedef boost::shared_ptr< ::turtlebot3_msgs::VersionInfo > VersionInfoPtr;
typedef boost::shared_ptr< ::turtlebot3_msgs::VersionInfo const> VersionInfoConstPtr;

// constants requiring out of line definition



template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> & v)
{
ros::message_operations::Printer< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >::stream(s, "", v);
return s;
}

} // namespace turtlebot3_msgs

namespace ros
{
namespace message_traits
{



// BOOLTRAITS {'IsFixedSize': False, 'IsMessage': True, 'HasHeader': False}
// {'std_msgs': ['/opt/ros/kinetic/share/std_msgs/cmake/../msg'], 'turtlebot3_msgs': ['/home/basti/projektarbeit/catkin_ws/src/turtlebot3_msgs/msg']}

// !!!!!!!!!!! ['__class__', '__delattr__', '__dict__', '__doc__', '__eq__', '__format__', '__getattribute__', '__hash__', '__init__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', '_parsed_fields', 'constants', 'fields', 'full_name', 'has_header', 'header_present', 'names', 'package', 'parsed_fields', 'short_name', 'text', 'types']




template <class ContainerAllocator>
struct IsFixedSize< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct IsFixedSize< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> const>
  : FalseType
  { };

template <class ContainerAllocator>
struct IsMessage< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct HasHeader< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct HasHeader< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> const>
  : FalseType
  { };


template<class ContainerAllocator>
struct MD5Sum< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
{
  static const char* value()
  {
    return "43e0361461af2970a33107409403ef3c";
  }

  static const char* value(const ::turtlebot3_msgs::VersionInfo_<ContainerAllocator>&) { return value(); }
  static const uint64_t static_value1 = 0x43e0361461af2970ULL;
  static const uint64_t static_value2 = 0xa33107409403ef3cULL;
};

template<class ContainerAllocator>
struct DataType< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
{
  static const char* value()
  {
    return "turtlebot3_msgs/VersionInfo";
  }

  static const char* value(const ::turtlebot3_msgs::VersionInfo_<ContainerAllocator>&) { return value(); }
};

template<class ContainerAllocator>
struct Definition< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
{
  static const char* value()
  {
    return "########################################\n\
# Messages\n\
########################################\n\
string hardware   # <yyyy>.<mm>.<dd>        : hardware version of Turtlebot3 (ex. 2017.05.23)\n\
string firmware   # <major>.<minor>.<patch> : firmware version of OpenCR\n\
string software   # <major>.<minor>.<patch> : software version of Turtlebot3 ROS packages\n\
";
  }

  static const char* value(const ::turtlebot3_msgs::VersionInfo_<ContainerAllocator>&) { return value(); }
};

} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

  template<class ContainerAllocator> struct Serializer< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
  {
    template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
    {
      stream.next(m.hardware);
      stream.next(m.firmware);
      stream.next(m.software);
    }

    ROS_DECLARE_ALLINONE_SERIALIZER
  }; // struct VersionInfo_

} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::turtlebot3_msgs::VersionInfo_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const ::turtlebot3_msgs::VersionInfo_<ContainerAllocator>& v)
  {
    s << indent << "hardware: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.hardware);
    s << indent << "firmware: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.firmware);
    s << indent << "software: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.software);
  }
};

} // namespace message_operations
} // namespace ros

#endif // TURTLEBOT3_MSGS_MESSAGE_VERSIONINFO_H